/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.Clases;

/**
 *
 * @author ancaj
 */
public class PeliculaBoletos {

    private String codigo;
    private String nombre;
    private String genero;
    private int duracionMinutos;
    private double precioBase;
    private String tipo;
    private String imagenUrl;
    private boolean estado;

    public PeliculaBoletos(){
    }

    public String getCodigo(){
        return codigo;
    }

    public void setCodigo(String codigo){
        this.codigo = codigo;
    }

    public String getNombre(){
        return nombre;
    }

    public void setNombre(String nombre){
        this.nombre = nombre;
    }

    public String getGenero(){
        if (genero == null || genero.trim().isEmpty()){
            genero = generarGeneroDesdeCodigo(codigo);
        }
        return genero;
    }

    public void setGenero(String genero){
        this.genero = genero;
    }

    public int getDuracionMinutos(){
        return duracionMinutos;
    }

    public void setDuracionMinutos(int duracionMinutos){
        this.duracionMinutos = duracionMinutos;
    }

    public double getPrecioBase(){
        return precioBase;
    }

    public void setPrecioBase(double precioBase){
        this.precioBase = precioBase;
    }

    public String getTipo(){
        if (tipo == null || tipo.trim().isEmpty()){
            tipo = generarTipoDesdeCodigo(codigo);
        }
        return tipo;
    }

    public void setTipo(String tipo){
        this.tipo = tipo;
    }

    public String getImagenUrl(){
        return imagenUrl;
    }

    public void setImagenUrl(String imagenUrl){
        this.imagenUrl = imagenUrl;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado){
        this.estado = estado;
    }

    private String generarGeneroDesdeCodigo(String codigoPelicula) {
        if (codigoPelicula == null || codigoPelicula.length() < 2) {
            return "";
        }

        String prefijo = codigoPelicula.substring(0, 2);

        switch(prefijo){
            case "01": return "Accion";
            case "02": return "Comedia";
            case "03": return "Drama";
            case "04": return "Terror";
            case "05": return "Ciencia ficcion";
            case "06": return "Aventura";
            case "07": return "Romance";
            case "08": return "Suspenso";
            default: return "";
        }
    }

    private String generarTipoDesdeCodigo(String codigoPelicula) {
        if(codigoPelicula == null || codigoPelicula.length() < 4){
            return "";
        }
        String tipoCodigo = codigoPelicula.substring(2, 4);
        if("00".equals(tipoCodigo)){
            return "2D";
        }
        if("01".equals(tipoCodigo)){
            return "3D";
        }
        return "";
    }
}
