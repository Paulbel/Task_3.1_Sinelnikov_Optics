package by.optics.controller.command.impl;

import by.optics.controller.ControllerConstant;
import by.optics.controller.command.Command;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SignOutCommand implements Command {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().removeAttribute(ControllerConstant.USER);
        try {
            response.sendRedirect(ControllerConstant.MAIN_PAGE_URI);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
