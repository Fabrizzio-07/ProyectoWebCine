package com.confiteria.dao;

import com.confiteria.modelo.YProducto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class YGestorProducto {

    public List<YProducto> listarProductosActivos() {
        List<YProducto> lista = new ArrayList<>();
        YGestorBaseDatos bd = new YGestorBaseDatos();
        Connection con = bd.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sql = "SELECT id_producto, nombre, precio, stock, categoria, estado, imagen FROM Producto WHERE estado = 1";

        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                YProducto p = new YProducto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setNombre(rs.getString("nombre"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setCategory(rs.getString("categoria"));
                p.setEstado(rs.getBoolean("estado"));
                p.setImagen(rs.getString("imagen"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar productos: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            bd.closeConnection(con);
        }
        return lista;
    }
}