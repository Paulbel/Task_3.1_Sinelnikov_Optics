package by.pharmacy.controller;

import by.pharmacy.controller.command.Command;
import by.pharmacy.controller.command.CommandInvoker;
import by.pharmacy.controller.command.impl.*;
import by.pharmacy.controller.command.MacroCommand;
import by.pharmacy.service.exception.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class FrontController extends HttpServlet {
    private static final long serialVersionUID = -2081650491757405193L;

    @Override
    public void init() throws ServletException {
        super.init();
        CommandInvoker commandInvoker = CommandInvoker.getInstance();
        Command command = new MacroCommand();
        command.addCommand(new GetLanguageCommand());
        command.addCommand(new GetDrugsCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.GET_LANGUAGE_AND_DRUGS_COMMAND,command);

        command = new MacroCommand();
        command.addCommand(new GetDrugsCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.GET_DRUGS_COMMAND,command);


        commandInvoker.addCommand(ControllerConstant.CHANGE_LANGUAGE_COMMAND,new ChangeLanguageCommand());

        command = new MacroCommand();
        command.addCommand(new GiveRoleCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.GIVE_ROLE_COMMAND,command);


        command = new MacroCommand();
        command.addCommand(new ShowAllUsersCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.SHOW_USERS_COMMAND,command);


        command = new MacroCommand();

        command.addCommand(new FindDrugCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.FIND_DRUG_COMMAND,command);


        command = new MacroCommand();

        command.addCommand(new SignInCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.SIGN_IN_COMMAND,command);


        command = new MacroCommand();
        command.addCommand(new AddDrugDescriptionCommand());
        command.addCommand(new EnterCabinetCommand());
        commandInvoker.addCommand(ControllerConstant.ADD_DESCRIPTION_COMMAND, command);

        commandInvoker.addCommand(ControllerConstant.SIGN_OUT_COMMAND,new SignOutCommand());

        commandInvoker.addCommand(ControllerConstant.SIGN_UP_COMMAND,new SignUpCommand());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeCommand(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeCommand(request, response);
    }

    private void executeCommand(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String commandName = request.getParameter(ControllerConstant.COMMAND_ATTRIBUTE);
        try {
            CommandInvoker commandInvoker = CommandInvoker.getInstance();
            commandInvoker.invokeCommand(commandName,request,response);
        } catch (ServiceException e) {
            e.printStackTrace();
        }
    }
}
