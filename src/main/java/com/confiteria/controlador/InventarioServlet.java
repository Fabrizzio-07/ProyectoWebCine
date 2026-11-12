
package com.confiteria.controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {



    // Procesa peticiones de los formularios 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            response.sendRedirect("inventario.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = new com.confiteria.dao.YGestorBaseDatos().getConnection();

            //mensaje éxito
            String tipoExito = "1"; 

            switch (accion) {
                
                case "crear":
                    // Recibe datos formulario nuevo prod
                    String nombreNuevo = request.getParameter("nombre");
                    double precioNuevo = Double.parseDouble(request.getParameter("precio"));
                    int stockNuevo = Integer.parseInt(request.getParameter("stock"));

                    String sqlCrear = "INSERT INTO Producto (nombre, precio, stock) VALUES (?, ?, ?)";
                    ps = conn.prepareStatement(sqlCrear);
                    ps.setString(1, nombreNuevo);
                    ps.setDouble(2, precioNuevo);
                    ps.setInt(3, stockNuevo);
                    ps.executeUpdate();
                    
                    //
                    tipoExito = "crear";
                    break;

                case "editar":
                    // datos actualizados
                    int idEditar = Integer.parseInt(request.getParameter("id"));
                    String nombreEdit = request.getParameter("nombre");
                    double precioEdit = Double.parseDouble(request.getParameter("precio"));

                    String sqlEditar = "UPDATE Producto SET nombre = ?, precio = ? WHERE id_producto = ?";
                    ps = conn.prepareStatement(sqlEditar);
                    ps.setString(1, nombreEdit);
                    ps.setDouble(2, precioEdit);
                    ps.setInt(3, idEditar);
                    ps.executeUpdate();
                    
                    tipoExito = "editar";
                    break;

                case "reponer":
                    // Suma la nueva cantidad al stock 
                    int idStock = Integer.parseInt(request.getParameter("id"));
                    int cantidadNueva = Integer.parseInt(request.getParameter("cantidad_nueva"));

                    String sqlStock = "UPDATE Producto SET stock = stock + ? WHERE id_producto = ?";
                    ps = conn.prepareStatement(sqlStock);
                    ps.setInt(1, cantidadNueva);
                    ps.setInt(2, idStock);
                    ps.executeUpdate();
                    
                    tipoExito = "reponer";
                    break;

                case "eliminar":
                    // eliminar el producto
                    int idEliminar = Integer.parseInt(request.getParameter("id"));

                    String sqlEliminar = "DELETE FROM Producto WHERE id_producto = ?";
                    ps = conn.prepareStatement(sqlEliminar);
                    ps.setInt(1, idEliminar);
                    ps.executeUpdate();
                    
                    tipoExito = "eliminar";
                    break;
            }

            // refresh
            response.sendRedirect("inventario.jsp?success=" + tipoExito);

        } catch (java.sql.SQLException ex) {
            ex.printStackTrace();
            // 4. Captura de la restricción de llave foránea de SQL Server
            if (ex.getErrorCode() == 547) {
                response.sendRedirect("inventario.jsp?error=restriccion");
            } else {
                response.sendRedirect("inventario.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventario.jsp?error=1");
        } finally {
            //Cierre
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}