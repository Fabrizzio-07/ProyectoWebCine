package com.confiteria.modelo;

public class YProducto {
    private int idProducto;
    private String nombre;
    private double precio;
    private int stock;
    private String categoria;
    private boolean estado;
    private String imagen; 

    public YProducto() {
    }

    //Constructor 
    public YProducto(int idProducto, String nombre, double precio, int stock, String categoria, boolean estado, String imagen) {
        this.idProducto = idProducto;
        this.nombre = nombre;
        this.precio = precio;
        this.stock = stock;
        this.categoria = categoria;
        this.estado = estado;
        this.imagen = imagen;
    }

    //Getters y setters
    public int getIdProducto() { return idProducto; }
    public void setIdProducto(int idProducto) { this.idProducto = idProducto; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getCategoria() { return categoria; }
    public void setCategory(String categoria) { this.categoria = categoria; }

    public boolean isEstado() { return estado; }
    public void setEstado(boolean estado) { this.estado = estado; }

    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }
}