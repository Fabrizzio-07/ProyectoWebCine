/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.BD;

/**
 *
 * @author ancaj
 */
import com.boletos.Clases.EstadisticaBoletosDTO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;

public class EstadisticasBoletosBD {

    private final ConexionBoletosSQL conexion = new ConexionBoletosSQL();

    public EstadisticaBoletosDTO obtenerEstadisticas(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        EstadisticaBoletosDTO dto = new EstadisticaBoletosDTO();

        dto.setTotalVentas(obtenerTotalVentas(fechaInicio, fechaFin, buscar));
        dto.setTotalBoletos(obtenerTotalBoletos(fechaInicio, fechaFin, buscar));
        dto.setMontoTotal(obtenerMontoTotal(fechaInicio, fechaFin, buscar));

        String mejorPelicula = obtenerMejorPeliculaPorIngreso(fechaInicio, fechaFin, buscar);
        dto.setMejorPelicula(mejorPelicula);

        if (mejorPelicula != null && !mejorPelicula.trim().isEmpty()) {
            dto.setBoletosVendidosMejorPelicula(
                    obtenerCantidadBoletosDePelicula(fechaInicio, fechaFin, mejorPelicula, buscar)
            );
            dto.setIngresoMejorPelicula(
                    obtenerIngresoDePelicula(fechaInicio, fechaFin, mejorPelicula, buscar)
            );
        } else {
            dto.setBoletosVendidosMejorPelicula(0);
            dto.setIngresoMejorPelicula(BigDecimal.ZERO);
        }

        dto.setMejorCajero(obtenerMejorCajeroPorIngreso(fechaInicio, fechaFin, buscar));

        return dto;
    }

    public EstadisticaBoletosDTO obtenerEstadisticas(LocalDate fechaInicio, LocalDate fechaFin) {
        return obtenerEstadisticas(fechaInicio, fechaFin, null);
    }

    public int obtenerTotalVentas(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) AS total ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al calcular total de ventas: " + e.getMessage(), e);
        }

        return 0;
    }

    public int obtenerTotalBoletos(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(va.id_venta_asiento) AS total ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.VentaAsientoBoleto va ON v.id_venta = va.id_venta ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al calcular total de boletos: " + e.getMessage(), e);
        }

        return 0;
    }

    public BigDecimal obtenerMontoTotal(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ISNULL(SUM(v.monto_total), 0) AS total ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal valor = rs.getBigDecimal("total");
                    return valor != null ? valor : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al calcular monto total: " + e.getMessage(), e);
        }

        return BigDecimal.ZERO;
    }

    public String obtenerMejorPeliculaPorIngreso(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP 1 pe.nombre AS nombre_pelicula, SUM(v.monto_total) AS ingreso ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        sql.append("GROUP BY pe.nombre ")
           .append("ORDER BY ingreso DESC, pe.nombre ASC");

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("nombre_pelicula");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener mejor película: " + e.getMessage(), e);
        }

        return null;
    }

    public BigDecimal obtenerIngresoDePelicula(LocalDate fechaInicio, LocalDate fechaFin, String nombrePelicula, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ISNULL(SUM(v.monto_total), 0) AS ingreso ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE pe.nombre = ? ");

        ArrayList<Object> parametros = new ArrayList<>();
        parametros.add(nombrePelicula);
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal valor = rs.getBigDecimal("ingreso");
                    return valor != null ? valor : BigDecimal.ZERO;
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener ingreso de película: " + e.getMessage(), e);
        }

        return BigDecimal.ZERO;
    }

    public int obtenerCantidadBoletosDePelicula(LocalDate fechaInicio, LocalDate fechaFin, String nombrePelicula, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(va.id_venta_asiento) AS total ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.VentaAsientoBoleto va ON v.id_venta = va.id_venta ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE pe.nombre = ? ");

        ArrayList<Object> parametros = new ArrayList<>();
        parametros.add(nombrePelicula);
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener cantidad de boletos de la película: " + e.getMessage(), e);
        }

        return 0;
    }

    public String obtenerMejorCajeroPorIngreso(LocalDate fechaInicio, LocalDate fechaFin, String buscar) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT TOP 1 p.nombre_completo, SUM(v.monto_total) AS ingreso ")
           .append("FROM dbo.VentaBoleto v ")
           .append("INNER JOIN dbo.Personal p ON v.id_personal = p.id_personal ")
           .append("INNER JOIN dbo.ClientesBoletos c ON v.id_cliente = c.id_cliente ")
           .append("INNER JOIN dbo.PeliculaBoleto pe ON v.codigo_pelicula = pe.codigo ")
           .append("WHERE 1 = 1 ");

        ArrayList<Object> parametros = new ArrayList<>();
        agregarFiltroFechas(sql, parametros, fechaInicio, fechaFin);
        agregarFiltroBusqueda(sql, parametros, buscar);

        sql.append("GROUP BY p.nombre_completo ")
           .append("ORDER BY ingreso DESC, p.nombre_completo ASC");

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            cargarParametros(ps, parametros);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("nombre_completo");
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener mejor cajero: " + e.getMessage(), e);
        }

        return null;
    }

    private void agregarFiltroFechas(StringBuilder sql, ArrayList<Object> parametros, LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaInicio != null) {
            sql.append("AND v.fecha_compra >= ? ");
            parametros.add(Date.valueOf(fechaInicio));
        }

        if (fechaFin != null) {
            sql.append("AND v.fecha_compra <= ? ");
            parametros.add(Date.valueOf(fechaFin));
        }
    }

    private void agregarFiltroBusqueda(StringBuilder sql, ArrayList<Object> parametros, String buscar) {
        if (buscar != null && !buscar.trim().isEmpty()) {
            sql.append("AND (c.nombre LIKE ? OR pe.nombre LIKE ? OR v.codigo_pelicula LIKE ?) ");
            String filtro = "%" + buscar.trim() + "%";
            parametros.add(filtro);
            parametros.add(filtro);
            parametros.add(filtro);
        }
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
            } else {
                ps.setObject(i + 1, valor);
            }
        }
    }
}
