package com.confiteria.dao;
import java.util.ArrayList;
import com.confiteria.modelo.Rol;
import com.confiteria.modelo.YPersonal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class YGestorPersonal {
    
    private YGestorBaseDatos db;

    public YGestorPersonal() {
        this.db = new YGestorBaseDatos();
    }

    //Método consulta si usuario y contraseña coinciden
    public YPersonal validarLogin(String usuario, String password) {
        YPersonal personalEncontrado = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        //verificar estado
        String sql = "SELECT p.id_personal, p.nombre_completo, p.usuario, p.estado, "
                   + "r.id_rol, r.nombre_rol "
                   + "FROM Personal p "
                   + "INNER JOIN Rol r ON p.id_rol = r.id_rol "
                   + "WHERE p.usuario = ? "
                   + "AND p.password = CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', CAST(? AS VARCHAR(255))), 2) "
                   + "AND p.estado = 1";

        try {
            con = db.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                personalEncontrado = new YPersonal();
                personalEncontrado.setIdPersonal(rs.getInt("id_personal"));
                personalEncontrado.setNombreCompleto(rs.getString("nombre_completo"));
                personalEncontrado.setUsuario(rs.getString("usuario"));
                personalEncontrado.setEstado(rs.getBoolean("estado"));
                
                //Encontrar rol
                Rol rol = new Rol();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setNombreRol(rs.getString("nombre_rol"));
                
                personalEncontrado.setRol(rol);
            }
        } catch (SQLException e) {
            System.out.println("Error en validarLogin: " + e.getMessage());
        } finally {
            //Cerrar
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            db.closeConnection(con);
        }

        return personalEncontrado; //Retorna nulo
    }
    // Método para listar todo el personal
public ArrayList<YPersonal> listarPersonal() {

    ArrayList<YPersonal> lista = new ArrayList<>();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = "SELECT p.id_personal, p.nombre_completo, p.usuario, "
            + "p.estado, r.id_rol, r.nombre_rol "
            + "FROM Personal p "
            + "INNER JOIN Rol r ON p.id_rol = r.id_rol";

    try {

        con = db.getConnection();

        ps = con.prepareStatement(sql);

        rs = ps.executeQuery();

        while (rs.next()) {

            YPersonal persona = new YPersonal();

            persona.setIdPersonal(rs.getInt("id_personal"));
            persona.setNombreCompleto(rs.getString("nombre_completo"));
            persona.setUsuario(rs.getString("usuario"));
            persona.setEstado(rs.getBoolean("estado"));

            Rol rol = new Rol();

            rol.setIdRol(rs.getInt("id_rol"));
            rol.setNombreRol(rs.getString("nombre_rol"));

            persona.setRol(rol);

            lista.add(persona);

        }

    } catch (SQLException e) {

        System.out.println("Error al listar personal: " + e.getMessage());

    } finally {

        try { if (rs != null) rs.close(); } catch (SQLException e) {}

        try { if (ps != null) ps.close(); } catch (SQLException e) {}

        db.closeConnection(con);

    }

    return lista;
}
public ArrayList<YPersonal> buscarPersonal(String texto, String rol) {

    ArrayList<YPersonal> lista = new ArrayList<>();

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = "SELECT p.id_personal, p.nombre_completo, p.usuario, p.estado, "
            + "r.id_rol, r.nombre_rol "
            + "FROM Personal p "
            + "INNER JOIN Rol r ON p.id_rol = r.id_rol "
            + "WHERE (p.nombre_completo LIKE ? OR p.usuario LIKE ?) ";

    //Si eligió un rol específico
    if (!rol.isEmpty()) {
        sql += "AND r.nombre_rol = ? ";
    }

    sql += "ORDER BY p.id_personal";

    try {

        con = db.getConnection();

        ps = con.prepareStatement(sql);

        ps.setString(1, "%" + texto + "%");
        ps.setString(2, "%" + texto + "%");

        if (!rol.isEmpty()) {
    ps.setString(3, rol);
}

        rs = ps.executeQuery();

        while (rs.next()) {

            YPersonal p = new YPersonal();

            p.setIdPersonal(rs.getInt("id_personal"));
            p.setNombreCompleto(rs.getString("nombre_completo"));
            p.setUsuario(rs.getString("usuario"));
            p.setEstado(rs.getBoolean("estado"));

            Rol r = new Rol();
            r.setIdRol(rs.getInt("id_rol"));
            r.setNombreRol(rs.getString("nombre_rol"));

            p.setRol(r);

            lista.add(p);
        }

    } catch (SQLException e) {

        System.out.println("Error buscarPersonal: " + e.getMessage());

    } finally {

        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {}

        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {}

        db.closeConnection(con);
    }

    return lista;
}
public boolean eliminarPersonal(int idPersonal){

    Connection con = null;
    PreparedStatement ps = null;

    String sql = "DELETE FROM Personal WHERE id_personal = ?";

    try{

        con = db.getConnection();

        ps = con.prepareStatement(sql);

        ps.setInt(1, idPersonal);

        return ps.executeUpdate() > 0;

    }catch(SQLException e){

        System.out.println("Error eliminarPersonal: " + e.getMessage());

    }finally{

        try{
            if(ps!=null) ps.close();
        }catch(SQLException e){}

        db.closeConnection(con);

    }

    return false;

}
public boolean insertarPersonal(YPersonal personal){

    Connection con = null;
    PreparedStatement ps = null;

    String sql =
    "INSERT INTO Personal(nombre_completo,usuario,password,id_rol,estado) "
    + "VALUES(?,?,?,?,?)";

    try{

        con = db.getConnection();

        ps = con.prepareStatement(sql);

        ps.setString(1, personal.getNombreCompleto());
        ps.setString(2, personal.getUsuario());
        ps.setString(3, personal.getPassword());
        ps.setInt(4, personal.getRol().getIdRol());
        ps.setBoolean(5, personal.isEstado());

        return ps.executeUpdate() > 0;

    }catch(SQLException e){

        System.out.println("Error al registrar: " + e.getMessage());

    }finally{

        try{
            if(ps!=null) ps.close();
        }catch(SQLException e){}

        db.closeConnection(con);

    }

    return false;
}
public YPersonal obtenerPersonal(int id) {

    YPersonal persona = null;

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String sql = "SELECT p.id_personal, p.nombre_completo, p.usuario, "
            + "p.password, p.estado, r.id_rol, r.nombre_rol "
            + "FROM Personal p "
            + "INNER JOIN Rol r ON p.id_rol = r.id_rol "
            + "WHERE p.id_personal = ?";

    try {

        con = db.getConnection();

        ps = con.prepareStatement(sql);
        ps.setInt(1, id);

        rs = ps.executeQuery();

        if (rs.next()) {

            persona = new YPersonal();

            persona.setIdPersonal(rs.getInt("id_personal"));
            persona.setNombreCompleto(rs.getString("nombre_completo"));
            persona.setUsuario(rs.getString("usuario"));
            persona.setPassword(rs.getString("password"));
            persona.setEstado(rs.getBoolean("estado"));

            Rol rol = new Rol();
            rol.setIdRol(rs.getInt("id_rol"));
            rol.setNombreRol(rs.getString("nombre_rol"));

            persona.setRol(rol);
        }

    } catch (SQLException e) {

        System.out.println("Error al obtener empleado: " + e.getMessage());

    } finally {

        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}

        db.closeConnection(con);
    }

    return persona;
}
public boolean actualizarPersonal(YPersonal personal){

    Connection con = null;
    PreparedStatement ps = null;

    String sql = "UPDATE Personal "
               + "SET nombre_completo=?, "
               + "usuario=?, "
               + "password=?, "
               + "id_rol=?, "
               + "estado=? "
               + "WHERE id_personal=?";

    try{

        con = db.getConnection();

        ps = con.prepareStatement(sql);

        ps.setString(1, personal.getNombreCompleto());
        ps.setString(2, personal.getUsuario());
        ps.setString(3, personal.getPassword());
        ps.setInt(4, personal.getRol().getIdRol());
        ps.setBoolean(5, personal.isEstado());
        ps.setInt(6, personal.getIdPersonal());

        return ps.executeUpdate() > 0;

    }catch(SQLException e){

        System.out.println("Error al actualizar: " + e.getMessage());

    }finally{

        try{
            if(ps != null) ps.close();
        }catch(SQLException e){}

        db.closeConnection(con);

    }

    return false;
}
}