package by.pharmacy.dao;

import by.pharmacy.dao.exception.DAOException;
import by.pharmacy.entity.Language;
import by.pharmacy.entity.Order;

import java.util.List;

public interface OrderDAO {

    void addOrder(Order order) throws DAOException;

    List<Order> getClientOrderList(String login, int number, int offset, Language language) throws DAOException;

    List<Order> getOrderList(int number, int offset, Language language) throws DAOException;

    int getOrderCount(String login, Language language) throws DAOException;
}
