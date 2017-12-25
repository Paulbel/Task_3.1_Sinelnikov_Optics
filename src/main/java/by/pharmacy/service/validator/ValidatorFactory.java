package by.pharmacy.service.validator;

import by.pharmacy.service.validator.impl.UserDataValidatorImpl;

public class ValidatorFactory {
    public static final ValidatorFactory instance = new ValidatorFactory();
    private UserDataValidator userDataValidator= new UserDataValidatorImpl();


    public UserDataValidator getUserDataValidator() {
        return userDataValidator;
    }

    public static ValidatorFactory getInstance() {
        return instance;
    }

    private ValidatorFactory() {
    }
}