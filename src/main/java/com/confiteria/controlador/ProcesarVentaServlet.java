package com.confiteria.controlador;

import com.boletos.Tools.BoletosUtil;
import com.confiteria.dao.YGestorBaseDatos;
import com.confiteria.modelo.YPersonal;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.TreeMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProcesarVentaServlet", urlPatterns = {"/ProcesarVentaServlet"})
public class ProcesarVentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // No permitir ventas anonimas ni atribuirlas a un empleado fijo.
        YPersonal cajero = BoletosUtil.obtenerUsuario(request);
        if (cajero == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!BoletosUtil.esCajero(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Se requiere el rol Cajero.");
            return;
        }

        Map<Integer, Integer> cantidades;
        try {
            cantidades = leerCarrito(request.getParameter("datosVenta"));
        } catch (RuntimeException ex) {
            response.sendRedirect(request.getContextPath() + "/ventas.jsp?error=1");
            return;
        }

        try (Connection conn = new YGestorBaseDatos().getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Consultar el precio real del servidor y bloquear los productos
                // durante esta transaccion. Se procesan IDs ordenados.
                Map<Integer, BigDecimal> subtotales = new TreeMap<>();
                BigDecimal total = BigDecimal.ZERO;
                String sqlProducto = "SELECT precio, stock FROM Producto WITH (UPDLOCK, HOLDLOCK) "
                        + "WHERE id_producto = ? AND estado = 1";
                String sqlStock = "UPDATE Producto SET stock = stock - ? "
                        + "WHERE id_producto = ? AND estado = 1 AND stock >= ?";

                try (PreparedStatement psProducto = conn.prepareStatement(sqlProducto);
                     PreparedStatement psStock = conn.prepareStatement(sqlStock)) {
                    for (Map.Entry<Integer, Integer> item : cantidades.entrySet()) {
                        int id = item.getKey();
                        int cantidad = item.getValue();

                        psProducto.setInt(1, id);
                        BigDecimal precio;
                        int disponible;
                        try (ResultSet rs = psProducto.executeQuery()) {
                            if (!rs.next()) {
                                throw new SQLException("Producto no disponible: " + id);
                            }
                            precio = rs.getBigDecimal("precio");
                            disponible = rs.getInt("stock");
                        }
                        if (precio == null || precio.signum() < 0 || disponible < cantidad) {
                            throw new SQLException("Stock o precio invalido para el producto: " + id);
                        }

                        psStock.setInt(1, cantidad);
                        psStock.setInt(2, id);
                        psStock.setInt(3, cantidad);
                        if (psStock.executeUpdate() != 1) {
                            throw new SQLException("Stock insuficiente para el producto: " + id);
                        }
                        BigDecimal subtotal = precio.multiply(BigDecimal.valueOf(cantidad));
                        subtotales.put(id, subtotal);
                        total = total.add(subtotal);
                    }
                }

                int idVenta;
                String sqlVenta = "INSERT INTO Venta (id_personal, fecha, total) VALUES (?, GETDATE(), ?)";
                try (PreparedStatement psVenta = conn.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS)) {
                    psVenta.setInt(1, cajero.getIdPersonal());
                    psVenta.setBigDecimal(2, total);
                    if (psVenta.executeUpdate() != 1) {
                        throw new SQLException("No se pudo registrar la venta.");
                    }
                    try (ResultSet rs = psVenta.getGeneratedKeys()) {
                        if (!rs.next()) {
                            throw new SQLException("No se obtuvo el identificador de venta.");
                        }
                        idVenta = rs.getInt(1);
                    }
                }

                String sqlDetalle = "INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, subtotal) "
                        + "VALUES (?, ?, ?, ?)";
                try (PreparedStatement psDetalle = conn.prepareStatement(sqlDetalle)) {
                    for (Map.Entry<Integer, Integer> item : cantidades.entrySet()) {
                        psDetalle.setInt(1, idVenta);
                        psDetalle.setInt(2, item.getKey());
                        psDetalle.setInt(3, item.getValue());
                        psDetalle.setBigDecimal(4, subtotales.get(item.getKey()));
                        if (psDetalle.executeUpdate() != 1) {
                            throw new SQLException("No se pudo registrar el detalle de venta.");
                        }
                    }
                }

                conn.commit();
            } catch (Exception ex) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackError) {
                    ex.addSuppressed(rollbackError);
                }
                getServletContext().log("No se pudo registrar la venta", ex);
                response.sendRedirect(request.getContextPath() + "/ventas.jsp?error=1");
                return;
            }
        } catch (SQLException ex) {
            getServletContext().log("Error de conexion durante la venta", ex);
            response.sendRedirect(request.getContextPath() + "/ventas.jsp?error=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/ventas.jsp?success=1");
    }

    private Map<Integer, Integer> leerCarrito(String json) {
        if (json == null || json.isBlank() || json.length() > 100000) {
            throw new IllegalArgumentException("Carrito vacio o demasiado grande.");
        }
        JsonElement raiz = JsonParser.parseString(json);
        if (!raiz.isJsonArray()) {
            throw new IllegalArgumentException("El carrito debe ser un arreglo.");
        }
        JsonArray items = raiz.getAsJsonArray();
        if (items.size() == 0 || items.size() > 100) {
            throw new IllegalArgumentException("Cantidad de productos invalida.");
        }

        Map<Integer, Integer> cantidades = new TreeMap<>();
        for (JsonElement elemento : items) {
            if (!elemento.isJsonObject()) {
                throw new IllegalArgumentException("Producto invalido.");
            }
            JsonObject producto = elemento.getAsJsonObject();
            if (!producto.has("id") || !producto.has("cant")) {
                throw new IllegalArgumentException("Faltan datos del producto.");
            }
            int id = producto.get("id").getAsBigDecimal().intValueExact();
            int cantidad = producto.get("cant").getAsBigDecimal().intValueExact();
            if (id <= 0 || cantidad <= 0) {
                throw new IllegalArgumentException("ID o cantidad invalida.");
            }
            cantidades.merge(id, cantidad, Math::addExact);
        }
        return cantidades;
    }
}
