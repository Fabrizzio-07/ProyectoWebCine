/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.BD;

/**
 *
 * @author ancaj
 */

import com.boletos.Clases.VentaAsientoBoletos;
import com.boletos.Clases.VentaBoletos;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;

public class VentaBoletosBD {

    private final ConexionBoletosSQL conexion = new ConexionBoletosSQL();

    public int registrarVenta(VentaBoletos venta, ArrayList<VentaAsientoBoletos> asientos){
        if(venta == null){
            throw new IllegalArgumentException("La venta no puede ser nula.");
        }
        if(asientos == null || asientos.isEmpty()){
            throw new IllegalArgumentException("Debe enviar al menos un asiento.");
        }
        if(venta.getIdHorario() <= 0){
            throw new IllegalArgumentException("Debe indicar un horario válido.");
        }
        if(venta.getCliente() == null || venta.getCliente().trim().isEmpty()){
            throw new IllegalArgumentException("El nombre del cliente es obligatorio.");
        }

        Connection con = null;
        PreparedStatement psVenta = null;
        PreparedStatement psAsiento = null;
        ResultSet rs = null;

        try{
            con = conexion.getConnection();
            con.setAutoCommit(false);

            if(venta.getFechaCompra() == null){
                venta.setFechaCompra(LocalDate.now());
            }
            if(venta.getHoraCompra() == null){
                venta.setHoraCompra(LocalTime.now().withNano(0));
            }

            int idCliente = obtenerOCrearCliente(con, venta.getCliente());
            validarAsientosDuplicados(asientos);

            for(int i = 0; i < asientos.size(); i++){
                VentaAsientoBoletos a = asientos.get(i);
                if (esAsientoOcupado(con, venta.getIdHorario(), a.getAsiento())){
                    throw new SQLException("El asiento " + a.getAsiento() + " ya fue vendido.");
                }
            }

            String sqlVenta = "INSERT INTO dbo.VentaBoleto "
                    + "(id_personal, id_cliente, codigo_pelicula, id_horario, fecha_compra, hora_compra, monto_total) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            psVenta = con.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);

            psVenta.setInt(1, venta.getIdPersonal());
            psVenta.setInt(2, idCliente);
            psVenta.setString(3, venta.getCodigoPelicula());
            psVenta.setInt(4, venta.getIdHorario());
            psVenta.setDate(5, Date.valueOf(venta.getFechaCompra()));
            psVenta.setTime(6, Time.valueOf(venta.getHoraCompra()));
            psVenta.setBigDecimal(7, venta.getMontoTotal());

            int filasAfectadas = psVenta.executeUpdate();
            if(filasAfectadas == 0){
                throw new SQLException("No se insertó la venta.");
            }

            int idVentaGenerado = -1;

            try(ResultSet rsKeys = psVenta.getGeneratedKeys()){
                if(rsKeys != null && rsKeys.next()){
                    idVentaGenerado = rsKeys.getInt(1);
                }
            }

            if(idVentaGenerado <= 0){
                idVentaGenerado = obtenerUltimoIdentity(con);
            }

            if(idVentaGenerado <= 0){
                throw new SQLException("No se pudo obtener el ID de la venta insertada.");
            }

            venta.setIdVenta(idVentaGenerado);

            String sqlAsiento = "INSERT INTO dbo.VentaAsientoBoleto (id_venta, asiento) VALUES (?, ?)";
            psAsiento = con.prepareStatement(sqlAsiento);

            for(int i = 0; i < asientos.size(); i++){
                VentaAsientoBoletos a = asientos.get(i);
                psAsiento.setInt(1, idVentaGenerado);
                psAsiento.setString(2, a.getAsiento().trim());
                psAsiento.executeUpdate();
            }

            incrementarFrecuenciaCliente(con, idCliente);

            con.commit();
            return idVentaGenerado;

        }catch(Exception e){
            if(con != null){
                try {
                    con.rollback();
                }catch (SQLException ex){
                    throw new RuntimeException("Error al realizar rollback: " + ex.getMessage(), ex);
                }
            }
            throw new RuntimeException("Error al registrar la venta: " + e.getMessage(), e);

        }finally{
            cerrarResultSet(rs);
            cerrarPreparedStatement(psAsiento);
            cerrarPreparedStatement(psVenta);
            cerrarConnection(con);
        }
    }

    public ArrayList<String> listarAsientosVendidos(int idHorario){
        ArrayList<String> lista = new ArrayList<>();
        String sql = "SELECT va.asiento "
                + "FROM dbo.VentaBoleto v "
                + "INNER JOIN dbo.VentaAsientoBoleto va ON v.id_venta = va.id_venta "
                + "WHERE v.id_horario = ? "
                + "ORDER BY va.asiento";

        try(Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){

            ps.setInt(1, idHorario);

            try(ResultSet rs = ps.executeQuery()){
                while (rs.next()) {
                    lista.add(rs.getString("asiento"));
                }
            }

        }catch(SQLException e){
            throw new RuntimeException("Error al listar asientos vendidos: " + e.getMessage(), e);
        }

        return lista;
    }

    public boolean asientoOcupado(int idHorario, String asiento) {
        String sql = "SELECT TOP 1 1 "
                + "FROM dbo.VentaBoleto v "
                + "INNER JOIN dbo.VentaAsientoBoleto va ON v.id_venta = va.id_venta "
                + "WHERE v.id_horario = ? "
                + "AND va.asiento = ?";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idHorario);
            ps.setString(2, asiento);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al verificar asiento ocupado: " + e.getMessage(), e);
        }
    }

    private boolean esAsientoOcupado(Connection con, int idHorario, String asiento) throws SQLException {
        String sql = "SELECT TOP 1 1 "
                + "FROM dbo.VentaBoleto v "
                + "INNER JOIN dbo.VentaAsientoBoleto va ON v.id_venta = va.id_venta "
                + "WHERE v.id_horario = ? "
                + "AND va.asiento = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idHorario);
            ps.setString(2, asiento);

            try (ResultSet rs = ps.executeQuery()){
                return rs.next();
            }
        }
    }

    private int obtenerOCrearCliente(Connection con, String nombreCliente) throws SQLException {
        String nombre = limpiarTexto(nombreCliente);

        String sqlBuscar = "SELECT TOP 1 id_cliente "
                + "FROM dbo.ClientesBoletos "
                + "WHERE UPPER(LTRIM(RTRIM(nombre))) = UPPER(LTRIM(RTRIM(?)))";

        try (PreparedStatement ps = con.prepareStatement(sqlBuscar)) {
            ps.setString(1, nombre);

            try (ResultSet rs = ps.executeQuery()){
                if (rs.next()) {
                    return rs.getInt("id_cliente");
                }
            }
        }

        String sqlInsert = "INSERT INTO dbo.ClientesBoletos (nombre, frecuencia) VALUES (?, 0)";

        try (PreparedStatement ps = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);

            int filas = ps.executeUpdate();
            if (filas == 0) {
                throw new SQLException("No se pudo crear el cliente.");
            }

            try(ResultSet rs = ps.getGeneratedKeys()){
                if(rs != null && rs.next()){
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("No se pudo obtener el ID del cliente.");
    }

    private void incrementarFrecuenciaCliente(Connection con, int idCliente) throws SQLException{
        String sql = "UPDATE dbo.ClientesBoletos "
                + "SET frecuencia = frecuencia + 1 "
                + "WHERE id_cliente = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            ps.executeUpdate();
        }
    }

    private int obtenerUltimoIdentity(Connection con) throws SQLException{
        String sql = "SELECT CAST(SCOPE_IDENTITY() AS INT) AS id_venta";

        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt("id_venta");
            }
        }

        return -1;
    }

    private void validarAsientosDuplicados(ArrayList<VentaAsientoBoletos> asientos){
        for (int i = 0; i < asientos.size(); i++) {
            String asientoI = limpiarTexto(asientos.get(i).getAsiento());
            for (int j = i + 1; j < asientos.size(); j++) {
                String asientoJ = limpiarTexto(asientos.get(j).getAsiento());
                if (asientoI.equals(asientoJ)) {
                    throw new IllegalArgumentException("Hay asientos duplicados en la misma venta: " + asientoI);
                }
            }
        }
    }

    private String limpiarTexto(String texto){
        if(texto == null){
            return "";
        }
        return texto.trim().toUpperCase();
    }

    private void cerrarPreparedStatement(PreparedStatement ps){
        if (ps != null){
            try {
                ps.close();
            } catch (SQLException ignored) {
            }
        }
    }

    private void cerrarResultSet(ResultSet rs){
        if(rs != null){
            try {
                rs.close();
            }catch (SQLException ignored){
            }
        }
    }

    private void cerrarConnection(Connection con) {
        if(con != null){
            try{
                con.close();
            }catch(SQLException ignored){
            }
        }
    }
}