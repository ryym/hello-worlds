package hello.jpa;

import javax.persistence.*;

public class App {
    public static void main(String[] args) {
        EntityManagerFactory emfactory = Persistence.createEntityManagerFactory("hello-jpa");
        
        EntityManager em = emfactory.createEntityManager();

        em.getTransaction().begin();

        User user = new User().setName("jon").setId(1);

        em.persist(user);
        em.getTransaction().commit();

        User jon = em.find(User.class, 1L);
        System.out.println(jon.getName());

        em.close();
        emfactory.close();

    }
}
