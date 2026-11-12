/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.boletos.BD.EstadisticasBoletosBD;
import com.boletos.Clases.EstadisticaBoletosDTO;
import java.io.IOException;
import java.time.LocalDate;
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
@WebServlet(name = "EstadisticasBoletosServlet", urlPatterns = {"/EstadisticasBoletosServlet"})
public class EstadisticasBoletosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final EstadisticasBoletosBD estadisticasBD = new EstadisticasBoletosBD();

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

    String buscar = request.getParameter("buscar");
    String fechaInicioStr = request.getParameter("fechaInicio");
    String fechaFinStr = request.getParameter("fechaFin");

    LocalDate fechaInicio = null;
    LocalDate fechaFin = null;

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

    EstadisticaBoletosDTO estadisticas = estadisticasBD.obtenerEstadisticas(fechaInicio, fechaFin, buscar);

    request.setAttribute("estadisticas", estadisticas);
    request.setAttribute("buscar", buscar != null ? buscar : "");
    request.setAttribute("fechaInicio", fechaInicio != null ? fechaInicio.toString() : "");
    request.setAttribute("fechaFin", fechaFin != null ? fechaFin.toString() : "");

    RequestDispatcher rd = request.getRequestDispatcher("/boletos_estadisticas.jsp");
    rd.forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
