package by.pharmacy.controller.command.impl.cabinet;

import by.pharmacy.controller.ControllerConstant;
import by.pharmacy.controller.command.Command;
import by.pharmacy.entity.Language;
import by.pharmacy.entity.User;
import by.pharmacy.service.UserService;
import by.pharmacy.service.exception.AccessDeniedException;
import by.pharmacy.service.exception.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class SignInCommand implements Command {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            UserService userService = serviceFactory.getUserService();

            String login = request.getParameter(ControllerConstant.LOGIN_ATTRIBUTE);
            String password = request.getParameter(ControllerConstant.PASSWORD_ATTRIBUTE);
            User user = userService.signIn(login, password);
            HttpSession session = request.getSession();

            if (session.getAttribute(ControllerConstant.LOCAL_ATTRIBUTE) == null) {
                session.setAttribute(ControllerConstant.LOCAL_ATTRIBUTE, Language.RU.toString().toLowerCase());
            }
            session.setAttribute(ControllerConstant.LOGIN_ATTRIBUTE, user.getLogin());
            session.setAttribute(ControllerConstant.NAME_ATTRIBUTE, user.getName());
            session.setAttribute(ControllerConstant.SURNAME_ATTRIBUTE, user.getSurname());
            session.setAttribute(ControllerConstant.ROLE_ATTRIBUTE, String.valueOf(user.getRole()));
        } catch (AccessDeniedException e) {
            request.setAttribute(ControllerConstant.PROBLEM_DESCRIPTION, ControllerConstant.WRONG_DATA);
        } catch (ServiceException e) {
            System.out.println("Cheburek");
        }


    }

}
