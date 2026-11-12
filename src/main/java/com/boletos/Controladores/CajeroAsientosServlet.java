/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.boletos.BD.HorarioFuncionBoletosBD;
import com.boletos.BD.PeliculaBoletosBD;
import com.boletos.BD.VentaBoletosBD;
import com.boletos.Clases.HorarioFuncionBoletos;
import com.boletos.Clases.PeliculaBoletos;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
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
@WebServlet(name = "CajeroAsientosServlet", urlPatterns = {"/CajeroAsientosServlet"})
public class CajeroAsientosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    private final PeliculaBoletosBD peliculaBD = new PeliculaBoletosBD();
    private final HorarioFuncionBoletosBD horarioBD = new HorarioFuncionBoletosBD();
    private final VentaBoletosBD ventaBD = new VentaBoletosBD();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!BoletosUtil.esCajero(request)) {
            if (BoletosUtil.esAdministrador(request)) {
                response.sendRedirect(request.getContextPath() + "/inicio.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            String idHorarioStr = request.getParameter("idHorario");
            String codigoPelicula = request.getParameter("codigoPelicula");
            String salaStr = request.getParameter("sala");
            String fechaFuncionStr = request.getParameter("fechaFuncion");
            String horaFuncionStr = request.getParameter("horaFuncion");
            String cliente = request.getParameter("cliente");

            HorarioFuncionBoletos horarioSeleccionado = null;

            if (idHorarioStr != null && !idHorarioStr.trim().isEmpty()) {
                int idHorario = Integer.parseInt(idHorarioStr.trim());
                horarioSeleccionado = horarioBD.obtenerPorId(idHorario);

                if (horarioSeleccionado != null) {
                    codigoPelicula = horarioSeleccionado.getCodigoPelicula();
                    salaStr = String.valueOf(horarioSeleccionado.getSala());
                    horaFuncionStr = horarioSeleccionado.getHoraFuncion() != null ? horarioSeleccionado.getHoraFuncion().toString() : horaFuncionStr;
                }
            }

            if (codigoPelicula != null && !codigoPelicula.trim().isEmpty()
                    && (horarioSeleccionado == null)) {
                ArrayList<HorarioFuncionBoletos> horarios = horarioBD.listarPorPelicula(codigoPelicula.trim());
                horarioSeleccionado = encontrarHorario(horarios, salaStr, horaFuncionStr);

                if (horarioSeleccionado != null) {
                    idHorarioStr = String.valueOf(horarioSeleccionado.getIdHorario());
                }
            }

            if (codigoPelicula == null || codigoPelicula.isBlank()
                    || salaStr == null || salaStr.isBlank()
                    || fechaFuncionStr == null || fechaFuncionStr.isBlank()
                    || horaFuncionStr == null || horaFuncionStr.isBlank()
                    || horarioSeleccionado == null) {
                response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
                return;
            }

            int idHorario = horarioSeleccionado.getIdHorario();
            int sala = horarioSeleccionado.getSala();
            LocalDate fechaFuncion = LocalDate.parse(fechaFuncionStr.trim());
            LocalTime horaFuncion = horarioSeleccionado.getHoraFuncion();

            PeliculaBoletos pelicula = peliculaBD.obtenerPorCodigo(codigoPelicula.trim());
            if (pelicula == null) {
                response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
                return;
            }

            ArrayList<HorarioFuncionBoletos> horarios = horarioBD.listarPorPelicula(codigoPelicula.trim());
            ArrayList<String> asientosVendidos = ventaBD.listarAsientosVendidos(idHorario);

            request.setAttribute("pelicula", pelicula);
            request.setAttribute("horarios", horarios);
            request.setAttribute("horarioSeleccionado", horarioSeleccionado);
            request.setAttribute("asientosVendidos", asientosVendidos);
            request.setAttribute("codigoPelicula", codigoPelicula.trim());
            request.setAttribute("idHorario", idHorario);
            request.setAttribute("sala", sala);
            request.setAttribute("fechaFuncion", fechaFuncion.toString());
            request.setAttribute("horaFuncion", horaFuncion.toString());
            request.setAttribute("cliente", cliente != null ? cliente : "");

            RequestDispatcher rd = request.getRequestDispatcher("/boletos_seleccionarAsientos.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException | DateTimeParseException ex) {
            response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private HorarioFuncionBoletos encontrarHorario(ArrayList<HorarioFuncionBoletos> horarios, String salaStr, String horaFuncionStr) {
        if (horarios == null || salaStr == null || horaFuncionStr == null) {
            return null;
        }

        int sala;
        LocalTime hora;

        try {
            sala = Integer.parseInt(salaStr.trim());
            hora = LocalTime.parse(horaFuncionStr.trim());
        } catch (Exception e) {
            return null;
        }

        for (int i = 0; i < horarios.size(); i++) {
            HorarioFuncionBoletos h = horarios.get(i);
            if (h.getSala() == sala && h.getHoraFuncion() != null && h.getHoraFuncion().equals(hora)) {
                return h;
            }
        }

        return null;
    }
}
