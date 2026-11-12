/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.BD;

/**
 *
 * @author ancaj
 */

import com.boletos.Clases.PeliculaBoletos;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class PeliculaBoletosBD {

    private final ConexionBoletosSQL conexion = new ConexionBoletosSQL();

    public ArrayList<PeliculaBoletos> listarPeliculas() {
        ArrayList<PeliculaBoletos> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre, duracion_minutos, precio_base, imagen_url, estado "
                   + "FROM dbo.PeliculaBoleto "
                   + "ORDER BY nombre";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                lista.add(mapearPelicula(rs));
            }

        }catch(SQLException e){
            throw new RuntimeException("Error al listar películas: " + e.getMessage(), e);
        }

        return lista;
    }

    public ArrayList<PeliculaBoletos> listarPeliculasActivas() {
        ArrayList<PeliculaBoletos> lista = new ArrayList<>();
        String sql = "SELECT codigo, nombre, duracion_minutos, precio_base, imagen_url, estado "
                   + "FROM dbo.PeliculaBoleto "
                   + "WHERE estado = 1 "
                   + "ORDER BY nombre";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()){

            while(rs.next()){
                lista.add(mapearPelicula(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar películas activas: " + e.getMessage(), e);
        }

        return lista;
    }

    public ArrayList<PeliculaBoletos> buscarPeliculasPorNombre(String texto){
        ArrayList<PeliculaBoletos> lista = new ArrayList<>();

        if (texto == null || texto.trim().isEmpty()) {
            return listarPeliculasActivas();
        }

        String sql = "SELECT codigo, nombre, duracion_minutos, precio_base, imagen_url, estado "
                   + "FROM dbo.PeliculaBoleto "
                   + "WHERE nombre LIKE ? AND estado = 1 "
                   + "ORDER BY nombre";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1, "%" + texto.trim() + "%");

            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    lista.add(mapearPelicula(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar películas: " + e.getMessage(), e);
        }

        return lista;
    }

    public PeliculaBoletos obtenerPorCodigo(String codigo) {
        String sql = "SELECT codigo, nombre, duracion_minutos, precio_base, imagen_url, estado "
                   + "FROM dbo.PeliculaBoleto "
                   + "WHERE codigo = ?";

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, codigo);

            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()){
                    return mapearPelicula(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener película por código: " + e.getMessage(), e);
        }

        return null;
    }

    public ArrayList<String> listarGeneros(){
        ArrayList<String> lista = new ArrayList<>();
        String sql = "SELECT nombre_genero "
                   + "FROM dbo.GeneroBoleto "
                   + "ORDER BY nombre_genero";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()){

            while (rs.next()) {
                lista.add(rs.getString("nombre_genero"));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar géneros: " + e.getMessage(), e);
        }

        return lista;
    }

    private PeliculaBoletos mapearPelicula(ResultSet rs) throws SQLException {
        PeliculaBoletos p = new PeliculaBoletos();
        p.setCodigo(rs.getString("codigo"));
        p.setNombre(rs.getString("nombre"));
        p.setDuracionMinutos(rs.getInt("duracion_minutos"));
        p.setPrecioBase(rs.getBigDecimal("precio_base").doubleValue());
        p.setImagenUrl(rs.getString("imagen_url"));
        p.setEstado(rs.getBoolean("estado"));
        return p;
    }
}
