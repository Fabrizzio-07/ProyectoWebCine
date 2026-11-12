/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.boletos.BD.HistorialBoletosBD;
import com.boletos.Clases.VentaBoletos;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ancaj
 */
@WebServlet(name = "ExportarBoletosCsvServlet", urlPatterns = {"/ExportarBoletosCsvServlet"})
public class ExportarBoletosCsvServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final HistorialBoletosBD historialBD = new HistorialBoletosBD();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"historial_boletos.csv\"");

        String filtro = request.getParameter("filtro");
        String buscar = request.getParameter("buscar");
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");

        LocalDate fechaInicio = null;
        LocalDate fechaFin = null;

        if ("hoy".equalsIgnoreCase(filtro)) {
            fechaInicio = LocalDate.now();
            fechaFin = LocalDate.now();
        } else {
            if (fechaInicioStr != null && !fechaInicioStr.trim().isEmpty()) {
                fechaInicio = LocalDate.parse(fechaInicioStr.trim());
            }
            if (fechaFinStr != null && !fechaFinStr.trim().isEmpty()) {
                fechaFin = LocalDate.parse(fechaFinStr.trim());
            }

            if (fechaInicio != null && fechaFin != null && fechaInicio.isAfter(fechaFin)) {
                LocalDate tmp = fechaInicio;
                fechaInicio = fechaFin;
                fechaFin = tmp;
            }
        }

        ArrayList<VentaBoletos> ventas = historialBD.listarHistorial(fechaInicio, fechaFin, buscar);

        try (PrintWriter out = response.getWriter()) {
            out.print('\ufeff');
            out.println("ID Venta;Fecha Compra;Hora Compra;Cliente;Película;Tipo;Sala;Fecha Función;Hora Función;Asientos;Total;Cajero");

            for (VentaBoletos v : ventas) {
                String asientos = historialBD.listarAsientosComoTexto(v.getIdVenta());
                out.println(
                        csv(v.getIdVenta()) + ";" +
                        csvDate(v.getFechaCompra()) + ";" +
                        csvTime(v.getHoraCompra()) + ";" +
                        csv(v.getCliente()) + ";" +
                        csv(v.getNombrePelicula()) + ";" +
                        csv(v.getTipo()) + ";" +
                        csv(v.getSala()) + ";" +
                        csvDate(v.getFechaFuncion()) + ";" +
                        csvTime(v.getHoraFuncion()) + ";" +
                        csv(asientos) + ";" +
                        csvMoney(v.getMontoTotal()) + ";" +
                        csv(v.getNombrePersonal())
                );
            }

            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }


    
    private String csv(Object valor) {
        if (valor == null) return "";
        String texto = String.valueOf(valor).trim();
        texto = texto.replace("\"", "\"\"");
        if (texto.contains(";") || texto.contains("\"") || texto.contains("\n") || texto.contains("\r")) {
            return "\"" + texto + "\"";
        }
        return texto;
    }

    private String csvDate(java.time.LocalDate valor) {
        if (valor == null) return "";
        return valor.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private String csvTime(java.time.LocalTime valor) {
        if (valor == null) return "";
        return valor.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"));
    }

    private String csvMoney(java.math.BigDecimal valor) {
        if (valor == null) return "";
        return String.format(java.util.Locale.US, "%.2f", valor.doubleValue());
    }

}
