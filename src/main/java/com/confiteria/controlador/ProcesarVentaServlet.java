package com.confiteria.controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.confiteria.modelo.YPersonal; 

@WebServlet(name = "ProcesarVentaServlet", urlPatterns = {"/ProcesarVentaServlet"})
public class ProcesarVentaServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String datosVentaJson = request.getParameter("datosVenta");
        
        if (datosVentaJson == null || datosVentaJson.trim().isEmpty()) {
            response.sendRedirect("ventas.jsp?error=1");
            return;
        }

        Connection conn = null;
        PreparedStatement psVenta = null;
        PreparedStatement psDetalle = null;
        PreparedStatement psStock = null;
        ResultSet rsKeys = null;

        try {
            conn = new com.confiteria.dao.YGestorBaseDatos().getConnection();
            conn.setAutoCommit(false); // Iniciamos transacción segura

            //Obtener ID de cajero
            HttpSession session = request.getSession();
            int idPersonal = 1; 
            
            YPersonal usuarioLogueado = (YPersonal) session.getAttribute("usuarioLogueado");
            if (usuarioLogueado != null) {
                idPersonal = usuarioLogueado.getIdPersonal(); 
            }

            //Extraer los datos del JSON 
            String[] productosJson = datosVentaJson.split("\\},\\{");
            
            Pattern pId = Pattern.compile("\"id\":\\s*(\\d+)");
            Pattern pPrecio = Pattern.compile("\"precio\":\\s*([\\d\\.]+)");
            Pattern pCant = Pattern.compile("\"cant\":\\s*(\\d+)");

            double totalVenta = 0.0;

            //Calcular total 
            for (String prodStr : productosJson) {
                double precio = 0;
                int cant = 0;
                
                Matcher mPrecio = pPrecio.matcher(prodStr);
                if (mPrecio.find()) precio = Double.parseDouble(mPrecio.group(1));

                Matcher mCant = pCant.matcher(prodStr);
                if (mCant.find()) cant = Integer.parseInt(mCant.group(1));

                totalVenta += (precio * cant);
            }

            //Insertar venta
            String sqlVenta = "INSERT INTO Venta (id_personal, fecha, total) VALUES (?, GETDATE(), ?)";
            psVenta = conn.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setInt(1, idPersonal);
            psVenta.setDouble(2, totalVenta);
            psVenta.executeUpdate();

            rsKeys = psVenta.getGeneratedKeys();
            int idVentaGenerado = 0;
            if (rsKeys.next()) {
                idVentaGenerado = rsKeys.getInt(1);
            }

            //Insertar detalle y descontar stock
            String sqlDetalle = "INSERT INTO DetalleVenta (id_venta, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)";
            String sqlStock = "UPDATE Producto SET stock = stock - ? WHERE id_producto = ?";
            
            psDetalle = conn.prepareStatement(sqlDetalle);
            psStock = conn.prepareStatement(sqlStock);

            for (String prodStr : productosJson) {
                int idProducto = 0;
                double precio = 0;
                int cant = 0;

                Matcher mId = pId.matcher(prodStr);
                if (mId.find()) idProducto = Integer.parseInt(mId.group(1));

                Matcher mPrecio = pPrecio.matcher(prodStr);
                if (mPrecio.find()) precio = Double.parseDouble(mPrecio.group(1));

                Matcher mCant = pCant.matcher(prodStr);
                if (mCant.find()) cant = Integer.parseInt(mCant.group(1));

                double subtotal = precio * cant;

                if (idProducto > 0 && cant > 0) {
                    psDetalle.setInt(1, idVentaGenerado);
                    psDetalle.setInt(2, idProducto);
                    psDetalle.setInt(3, cant);
                    psDetalle.setDouble(4, subtotal);
                    psDetalle.executeUpdate();

                    psStock.setInt(1, cant);
                    psStock.setInt(2, idProducto);
                    psStock.executeUpdate();
                }
            }

            conn.commit(); 
            response.sendRedirect("ventas.jsp?success=1");

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) {}
            }
            e.printStackTrace();
            response.sendRedirect("ventas.jsp?error=1");
        } finally {
            try { if (rsKeys != null) rsKeys.close(); } catch (Exception e) {}
            try { if (psVenta != null) psVenta.close(); } catch (Exception e) {}
            try { if (psDetalle != null) psDetalle.close(); } catch (Exception e) {}
            try { if (psStock != null) psStock.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
}