package by.optics.service.impl;

import by.optics.dao.DAOFactory;
import by.optics.dao.UserDAO;
import by.optics.dao.exception.DAOException;
import by.optics.entity.user.User;
import by.optics.service.UserDataValidator;
import by.optics.service.UserService;
import by.optics.service.exception.ServiceException;
import by.optics.service.exception.WrongPasswordException;
import com.sun.xml.internal.ws.developer.MemberSubmissionAddressing;

public class UserServiceImpl implements UserService{


    @Override
    public User signIn(String login, String password) throws ServiceException {
        try {
            DAOFactory daoFactory = DAOFactory.getInstance();
            UserDAO userDAO = daoFactory.getUserDAO();
            User foundUser = userDAO.findUserByLogin(login);
            UserDataValidator validator = new UserDataValidator();
            validator.checkPassword(foundUser,password);
            return foundUser;
        } catch (DAOException e) {
            throw new ServiceException(e.getMessage(),e);
        }
    }


    @Override
    public void registration(User user) {
        //TODO validation that checks parameters and if user with this login and email exists
        DAOFactory daoFactory = DAOFactory.getInstance();
        UserDAO userDAO = daoFactory.getUserDAO();
        try {
            userDAO.registration(user);
        } catch (DAOException e) {
            e.printStackTrace();
        }
    }
}
