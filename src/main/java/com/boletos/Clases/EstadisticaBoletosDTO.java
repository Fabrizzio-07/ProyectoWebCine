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

public class EstadisticaBoletosDTO {

    private int totalVentas;
    private int totalBoletos;
    private BigDecimal montoTotal;
    private String mejorPelicula;
    private String mejorCajero;
    private int boletosVendidosMejorPelicula;
    private BigDecimal ingresoMejorPelicula;

    public EstadisticaBoletosDTO() {
        this.montoTotal = BigDecimal.ZERO;
        this.ingresoMejorPelicula = BigDecimal.ZERO;
    }

    public EstadisticaBoletosDTO(int totalVentas, int totalBoletos, BigDecimal montoTotal, String mejorPelicula, String mejorCajero, int boletosVendidosMejorPelicula, BigDecimal ingresoMejorPelicula) {
        this.totalVentas = totalVentas;
        this.totalBoletos = totalBoletos;
        this.montoTotal = montoTotal;
        this.mejorPelicula = mejorPelicula;
        this.mejorCajero = mejorCajero;
        this.boletosVendidosMejorPelicula = boletosVendidosMejorPelicula;
        this.ingresoMejorPelicula = ingresoMejorPelicula;
    }

    public int getTotalVentas() {
        return totalVentas;
    }

    public void setTotalVentas(int totalVentas) {
        this.totalVentas = totalVentas;
    }

    public int getTotalBoletos() {
        return totalBoletos;
    }

    public void setTotalBoletos(int totalBoletos) {
        this.totalBoletos = totalBoletos;
    }

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal) {
        this.montoTotal = montoTotal;
    }

    public String getMejorPelicula() {
        return mejorPelicula;
    }

    public void setMejorPelicula(String mejorPelicula) {
        this.mejorPelicula = mejorPelicula;
    }

    public String getMejorCajero() {
        return mejorCajero;
    }

    public void setMejorCajero(String mejorCajero) {
        this.mejorCajero = mejorCajero;
    }

    public int getBoletosVendidosMejorPelicula() {
        return boletosVendidosMejorPelicula;
    }

    public void setBoletosVendidosMejorPelicula(int boletosVendidosMejorPelicula) {
        this.boletosVendidosMejorPelicula = boletosVendidosMejorPelicula;
    }

    public BigDecimal getIngresoMejorPelicula() {
        return ingresoMejorPelicula;
    }

    public void setIngresoMejorPelicula(BigDecimal ingresoMejorPelicula) {
        this.ingresoMejorPelicula = ingresoMejorPelicula;
    }
}
