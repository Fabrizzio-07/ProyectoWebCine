/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.Clases;

/**
 *
 * @author ancaj
 */
import java.time.LocalTime;

public class HorarioFuncionBoletos {

    private int idHorario;
    private String codigoPelicula;
    private int sala;
    private LocalTime horaFuncion;

    public HorarioFuncionBoletos() {
    }

    public HorarioFuncionBoletos(int idHorario, String codigoPelicula, int sala, LocalTime horaFuncion){
        this.idHorario = idHorario;
        this.codigoPelicula = codigoPelicula;
        this.sala = sala;
        this.horaFuncion = horaFuncion;
    }

    public int getIdHorario() {
        return idHorario;
    }

    public void setIdHorario(int idHorario) {
        this.idHorario = idHorario;
    }

    public String getCodigoPelicula() {
        return codigoPelicula;
    }

    public void setCodigoPelicula(String codigoPelicula) {
        this.codigoPelicula = codigoPelicula;
    }

    public int getSala() {
        return sala;
    }

    public void setSala(int sala) {
        this.sala = sala;
    }

    public LocalTime getHoraFuncion() {
        return horaFuncion;
    }

    public void setHoraFuncion(LocalTime horaFuncion) {
        this.horaFuncion = horaFuncion;
    }
}
