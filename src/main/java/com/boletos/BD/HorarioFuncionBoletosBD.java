/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.BD;

/**
 *
 * @author ancaj
 */

import com.boletos.Clases.HorarioFuncionBoletos;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalTime;
import java.util.ArrayList;

public class HorarioFuncionBoletosBD {

    private final ConexionBoletosSQL conexion = new ConexionBoletosSQL();

    public ArrayList<HorarioFuncionBoletos> listarHorarios() {
        ArrayList<HorarioFuncionBoletos> lista = new ArrayList<>();
        String sql = "SELECT id_horario, codigo_pelicula, sala, hora_funcion "
                   + "FROM dbo.HorarioFuncionBoleto "
                   + "ORDER BY codigo_pelicula, sala, hora_funcion";

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearHorario(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar horarios: " + e.getMessage(), e);
        }

        return lista;
    }

    public ArrayList<HorarioFuncionBoletos> listarPorPelicula(String codigoPelicula) {
        ArrayList<HorarioFuncionBoletos> lista = new ArrayList<>();
        String sql = "SELECT id_horario, codigo_pelicula, sala, hora_funcion "
                   + "FROM dbo.HorarioFuncionBoleto "
                   + "WHERE codigo_pelicula = ? "
                   + "ORDER BY sala, hora_funcion";

        try (Connection con = conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)){
            
            ps.setString(1, codigoPelicula);
            
            try(ResultSet rs = ps.executeQuery()){
                while(rs.next()){
                    lista.add(mapearHorario(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al listar horarios por película: " + e.getMessage(), e);
        }

        return lista;
    }

    public HorarioFuncionBoletos obtenerPorId(int idHorario) {
        String sql = "SELECT id_horario, codigo_pelicula, sala, hora_funcion "
                   + "FROM dbo.HorarioFuncionBoleto "
                   + "WHERE id_horario = ?";

        try (Connection con = conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idHorario);

            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()){
                    return mapearHorario(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener horario por ID: " + e.getMessage(), e);
        }

        return null;
    }

    private HorarioFuncionBoletos mapearHorario(ResultSet rs) throws SQLException {
        HorarioFuncionBoletos h = new HorarioFuncionBoletos();
        h.setIdHorario(rs.getInt("id_horario"));
        h.setCodigoPelicula(rs.getString("codigo_pelicula"));
        h.setSala(rs.getInt("sala"));

        Time t = rs.getTime("hora_funcion");
        if(t != null){
            h.setHoraFuncion(t.toLocalTime());
        }else{
            h.setHoraFuncion((LocalTime) null);
        }

        return h;
    }
}
