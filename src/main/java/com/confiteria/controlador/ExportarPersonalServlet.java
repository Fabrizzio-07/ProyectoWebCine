package com.confiteria.controlador;

import com.confiteria.dao.YGestorPersonal;
import com.confiteria.modelo.YPersonal;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet("/ExportarPersonalServlet")
public class ExportarPersonalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        YGestorPersonal gestor = new YGestorPersonal();
        ArrayList<YPersonal> lista = gestor.listarPersonal();

        Workbook libro = new XSSFWorkbook();

        Sheet hoja = libro.createSheet("Personal");

        Row encabezado = hoja.createRow(0);

        encabezado.createCell(0).setCellValue("ID");
        encabezado.createCell(1).setCellValue("Nombre");
        encabezado.createCell(2).setCellValue("Usuario");
        encabezado.createCell(3).setCellValue("Rol");
        encabezado.createCell(4).setCellValue("Estado");

        int fila = 1;

        for(YPersonal p : lista){

            Row row = hoja.createRow(fila++);

            row.createCell(0).setCellValue(p.getIdPersonal());
            row.createCell(1).setCellValue(p.getNombreCompleto());
            row.createCell(2).setCellValue(p.getUsuario());
            row.createCell(3).setCellValue(p.getRol().getNombreRol());

            if(p.isEstado()){
                row.createCell(4).setCellValue("Activo");
            }else{
                row.createCell(4).setCellValue("Inactivo");
            }

        }

        for(int i=0;i<5;i++){
            hoja.autoSizeColumn(i);
        }

        response.setContentType(
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        response.setHeader(
        "Content-Disposition",
        "attachment; filename=Personal.xlsx");

        libro.write(response.getOutputStream());

        libro.close();

    }

}