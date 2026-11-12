/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.boletos.BD.HistorialBoletosBD;
import com.boletos.Clases.VentaAsientoBoletos;
import com.boletos.Clases.VentaBoletos;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ancaj
 */
@WebServlet(name = "HistorialBoletosServlet", urlPatterns = {"/HistorialBoletosServlet"})
public class HistorialBoletosServlet extends HttpServlet {

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
        
        if (!BoletosUtil.esAdministrador(request)) {
            if (BoletosUtil.esCajero(request)) {
                response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String filtro = request.getParameter("filtro");
        String buscar = request.getParameter("buscar");
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");
        String idVentaDetalleStr = request.getParameter("idVentaDetalle");

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

        ArrayList<VentaBoletos> historial = historialBD.listarHistorial(fechaInicio, fechaFin, buscar);

        request.setAttribute("historial", historial);
        request.setAttribute("buscar", buscar != null ? buscar : "");
        request.setAttribute("fechaInicio", fechaInicio != null ? fechaInicio.toString() : "");
        request.setAttribute("fechaFin", fechaFin != null ? fechaFin.toString() : "");
        request.setAttribute("filtro", filtro != null ? filtro : "");

        if (idVentaDetalleStr != null && !idVentaDetalleStr.trim().isEmpty()) {
            try {
                int idVentaDetalle = Integer.parseInt(idVentaDetalleStr.trim());
                VentaBoletos ventaDetalle = historialBD.obtenerVentaPorId(idVentaDetalle);
                ArrayList<VentaAsientoBoletos> asientosDetalle = historialBD.listarAsientosPorVenta(idVentaDetalle);
                request.setAttribute("ventaDetalle", ventaDetalle);
                request.setAttribute("asientosDetalle", asientosDetalle);
                request.setAttribute("asientosDetalleTexto", historialBD.listarAsientosComoTexto(idVentaDetalle));
            } catch (NumberFormatException ignored) {
            }
        }

        RequestDispatcher rd = request.getRequestDispatcher("/boletos_historial.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
