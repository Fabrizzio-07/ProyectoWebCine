/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.Clases;

/**
 *
 * @author ancaj
 */
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

public class VentaBoletos {

    private int idVenta;
    private int idPersonal;
    private int idHorario;
    private String nombrePersonal;
    private String cliente;
    private String codigoPelicula;
    private String nombrePelicula;
    private String tipo;
    private int sala;
    private LocalTime horaFuncion;
    private LocalDate fechaFuncion;
    private LocalTime horaCompra;
    private LocalDate fechaCompra;
    private BigDecimal montoTotal;

    public VentaBoletos(){
    }

    public int getIdVenta(){
        return idVenta;
    }

    public void setIdVenta(int idVenta){
        this.idVenta = idVenta;
    }

    public int getIdPersonal(){
        return idPersonal;
    }

    public void setIdPersonal(int idPersonal){
        this.idPersonal = idPersonal;
    }

    public int getIdHorario(){
        return idHorario;
    }

    public void setIdHorario(int idHorario){
        this.idHorario = idHorario;
    }

    public String getNombrePersonal(){
        return nombrePersonal;
    }

    public void setNombrePersonal(String nombrePersonal){
        this.nombrePersonal = nombrePersonal;
    }

    public String getCliente(){
        return cliente;
    }

    public void setCliente(String cliente){
        this.cliente = cliente;
    }

    public String getCodigoPelicula(){
        return codigoPelicula;
    }

    public void setCodigoPelicula(String codigoPelicula){
        this.codigoPelicula = codigoPelicula;
    }

    public String getNombrePelicula(){
        return nombrePelicula;
    }

    public void setNombrePelicula(String nombrePelicula){
        this.nombrePelicula = nombrePelicula;
    }

    public String getTipo(){
        return tipo;
    }

    public void setTipo(String tipo){
        this.tipo = tipo;
    }

    public int getSala(){
        return sala;
    }

    public void setSala(int sala){
        this.sala = sala;
    }

    public LocalTime getHoraFuncion(){
        return horaFuncion;
    }

    public void setHoraFuncion(LocalTime horaFuncion){
        this.horaFuncion = horaFuncion;
    }

    public LocalDate getFechaFuncion(){
        return fechaFuncion;
    }

    public void setFechaFuncion(LocalDate fechaFuncion){
        this.fechaFuncion = fechaFuncion;
    }

    public LocalTime getHoraCompra(){
        return horaCompra;
    }

    public void setHoraCompra(LocalTime horaCompra){
        this.horaCompra = horaCompra;
    }

    public LocalDate getFechaCompra(){
        return fechaCompra;
    }

    public void setFechaCompra(LocalDate fechaCompra){
        this.fechaCompra = fechaCompra;
    }

    public BigDecimal getMontoTotal(){
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal){
        this.montoTotal = montoTotal;
    }
}

