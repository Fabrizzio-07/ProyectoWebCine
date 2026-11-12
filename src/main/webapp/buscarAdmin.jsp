<%@page import="java.sql.*"%><%@page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%><%
    String nombreAdmin = "";
    try {
        //SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        

        //Tabla->Personal columna->rol
        String sql = "SELECT TOP 1 nombre_completo FROM Personal WHERE rol LIKE '%Admin%'";
        
        try (Connection conn = new com.confiteria.dao.YGestorBaseDatos().getConnection(); ///////
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                nombreAdmin = rs.getString("nombre_completo");
            }
        }
    } catch (Exception e) {
        //Error 
    }
    out.print(nombreAdmin.trim());
%>