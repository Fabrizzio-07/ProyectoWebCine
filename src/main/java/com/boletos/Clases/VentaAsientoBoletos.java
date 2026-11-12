/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.Clases;

/**
 *
 * @author ancaj
 */

public class VentaAsientoBoletos {

    private int idVentaAsiento;
    private int idVenta;
    private String asiento;

    public VentaAsientoBoletos(){
    }

    public VentaAsientoBoletos(int idVentaAsiento, int idVenta, String asiento){
        this.idVentaAsiento = idVentaAsiento;
        this.idVenta = idVenta;
        this.asiento = asiento;
    }

    public int getIdVentaAsiento(){
        return idVentaAsiento;
    }

    public void setIdVentaAsiento(int idVentaAsiento) {
        this.idVentaAsiento = idVentaAsiento;
    }

    public int getIdVenta() {
        return idVenta;
    }

    public void setIdVenta(int idVenta) {
        this.idVenta = idVenta;
    }

    public String getAsiento() {
        return asiento;
    }

    public void setAsiento(String asiento) {
        this.asiento = asiento;
    }
}
