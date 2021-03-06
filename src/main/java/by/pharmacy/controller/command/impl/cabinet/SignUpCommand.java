package by.pharmacy.controller.command.impl.cabinet;

import by.pharmacy.controller.ControllerConstant;
import by.pharmacy.controller.command.Command;
import by.pharmacy.entity.User;
import by.pharmacy.service.ServiceFactory;
import by.pharmacy.service.UserService;
import by.pharmacy.service.exception.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SignUpCommand implements Command {
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, ServiceException {
        String name = request.getParameter(ControllerConstant.NAME_ATTRIBUTE);
        String surname = request.getParameter(ControllerConstant.SURNAME_ATTRIBUTE);
        String login = request.getParameter(ControllerConstant.LOGIN_ATTRIBUTE);
        String password = request.getParameter(ControllerConstant.PASSWORD_ATTRIBUTE);
        String phone = request.getParameter(ControllerConstant.PHONE_ATTRIBUTE);
        String email = request.getParameter(ControllerConstant.EMAIL_ATTRIBUTE);

        User user = new User();
        user.setName(name);
        user.setSurname(surname);
        user.setLogin(login);
        user.setEmail(email);
        user.setPhoneNumber(phone);

        ServiceFactory factory = ServiceFactory.getInstance();
        UserService service = factory.getUserService();
        service.signUp(user, password);
        response.sendRedirect(ControllerConstant.MAIN_PAGE_URI);
    }
}
