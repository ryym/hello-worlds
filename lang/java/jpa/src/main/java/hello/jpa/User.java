package hello.jpa;

import javax.persistence.*;
import java.io.Serializable;


@Entity
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
   @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name ="id")
    private long id;

    @Column(name = "name")
    private String name;

    public User setId(long id) {
        this.id = id;
        return this;
    }
    
    public User setName(String name) {
        this.name = name;
        return this;
    }

    public long getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

}
