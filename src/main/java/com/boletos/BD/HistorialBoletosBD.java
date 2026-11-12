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
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;

public class HistorialBoletosBD {

    private final ConexionBoletosSQL conexion = new ConexionBoletosSQL();

    public ArrayList<VentaBoletos> listarHistorial(LocalDate fechaInicio, LocalDate fechaFin, String textoBusqueda) {
        ArrayList<VentaBoletos> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT v.id_venta, v.id_personal, p.nombre_completo AS nombre_personal, ")
           .append("v.id_cliente, c.nombre AS cliente, v.codigo_pelicula, pe.nombre AS nombre_pelicula, ")
           .append("v.id_horario, h.sala, h.hora_funcion, v.fecha_compra, v.hora_compra, v.monto_total ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.Personal p ON v.id_personal = p.id_personal ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("INNER JOIN dbo.HorarioFuncionBoleto h ON v.id_horario = h.id_horario ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();

        if (fechaInicio != null) {
            sql.append("AND v.fecha_compra >= ? ");
            parametros.add(Date.valueOf(fechaInicio));
        }

        if (fechaFin != null) {
            sql.append("AND v.fecha_compra <= ? ");
            parametros.add(Date.valueOf(fechaFin));
        }

        if (textoBusqueda != null && !textoBusqueda.trim().isEmpty()) {
            sql.append("AND (c.nombre LIKE ? OR pe.nombre LIKE ? OR v.codigo_pelicula LIKE ?) ");
            String filtro = "%" + textoBusqueda.trim() + "%";
            parametros.add(filtro);
            parametros.add(filtro);
            parametros.add(filtro);
        }

        sql.append("ORDER BY v.fecha_compra DESC, v.hora_compra DESC, v.id_venta DESC");

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearVenta(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar historial: " + e.getMessage(), e);
        }

        return lista;
    }

    public VentaBoletos obtenerVentaPorId(int idVenta) {
        String sql = "SELECT v.id_venta, v.id_personal, p.nombre_completo AS nombre_personal, "
                + "v.id_cliente, c.nombre AS cliente, v.codigo_pelicula, pe.nombre AS nombre_pelicula, "
                + "v.id_horario, h.sala, h.hora_funcion, v.fecha_compra, v.hora_compra, v.monto_total "
                + "FROM dbo.VentaBoleto v "
                + "INNER JOIN dbo.Personal p ON v.id_personal = p.id_personal "
                + "INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente "
                + "INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo "
                + "INNER JOIN dbo.HorarioFuncionBoleto h ON v.id_horario = h.id_horario "
                + "WHERE v.id_venta = ?";

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearVenta(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener venta por ID: " + e.getMessage(), e);
        }

        return null;
    }

    public ArrayList<VentaAsientoBoletos> listarAsientosPorVenta(int idVenta) {
        ArrayList<VentaAsientoBoletos> lista = new ArrayList<>();

        String sql = "SELECT id_venta_asiento, id_venta, asiento "
                + "FROM dbo.VentaAsientoBoleto "
                + "WHERE id_venta = ? "
                + "ORDER BY asiento";

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVenta);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VentaAsientoBoletos a = new VentaAsientoBoletos();
                    a.setIdVentaAsiento(rs.getInt("id_venta_asiento"));
                    a.setIdVenta(rs.getInt("id_venta"));
                    a.setAsiento(rs.getString("asiento"));
                    lista.add(a);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar asientos por venta: " + e.getMessage(), e);
        }

        return lista;
    }

    public String listarAsientosComoTexto(int idVenta) {
        ArrayList<VentaAsientoBoletos> lista = listarAsientosPorVenta(idVenta);
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < lista.size(); i++) {
            if (i > 0) {
                sb.append(", ");
            }
            sb.append(lista.get(i).getAsiento());
        }

        return sb.toString();
    }

    private VentaBoletos mapearVenta(ResultSet rs) throws SQLException {
        VentaBoletos v = new VentaBoletos();
        v.setIdVenta(rs.getInt("id_venta"));
        v.setIdPersonal(rs.getInt("id_personal"));
        v.setNombrePersonal(rs.getString("nombre_personal"));
        v.setCliente(rs.getString("cliente"));
        v.setCodigoPelicula(rs.getString("codigo_pelicula"));
        v.setNombrePelicula(rs.getString("nombre_pelicula"));
        v.setTipo(tipoDesdeCodigo(rs.getString("codigo_pelicula")));
        v.setIdHorario(rs.getInt("id_horario"));
        v.setSala(rs.getInt("sala"));

        Time horaFuncion = rs.getTime("hora_funcion");
        if (horaFuncion != null) {
            v.setHoraFuncion(horaFuncion.toLocalTime());
        }

        Date fechaCompra = rs.getDate("fecha_compra");
        if (fechaCompra != null) {
            v.setFechaCompra(fechaCompra.toLocalDate());
        }

        Time horaCompra = rs.getTime("hora_compra");
        if (horaCompra != null) {
            v.setHoraCompra(horaCompra.toLocalTime());
        }

        v.setMontoTotal(rs.getBigDecimal("monto_total"));
        return v;
    }

    private String tipoDesdeCodigo(String codigo) {
        if (codigo == null || codigo.length() < 4) {
            return "";
        }

        String tipoCodigo = codigo.substring(2, 4);

        if ("00".equals(tipoCodigo)) {
            return "2D";
        }
        if ("01".equals(tipoCodigo)) {
            return "3D";
        }
        return "";
    }

    private void cargarParametros(PreparedStatement ps, ArrayList<Object> parametros) throws SQLException {
        for (int i = 0; i < parametros.size(); i++) {
            Object valor = parametros.get(i);

            if (valor instanceof Date) {
                ps.setDate(i + 1, (Date) valor);
            } else if (valor instanceof String) {
                ps.setString(i + 1, (String) valor);
            } else if (valor instanceof Integer) {
                ps.setInt(i + 1, (Integer) valor);
            } else if (valor instanceof Time) {
                ps.setTime(i + 1, (Time) valor);
            } else {
                ps.setObject(i + 1, valor);
            }
        }
    }
}