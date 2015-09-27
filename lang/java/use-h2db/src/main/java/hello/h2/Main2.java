package hello.h2;

import java.sql.Connection;
import java.sql.Driver;
import java.sql.ResultSet;
import java.util.Properties;

public class Main2 {
    public static void main(String[] args) throws Exception {
        Driver driver = (Driver)Class.forName("org.h2.Driver").newInstance();

        Properties props = new Properties();
        props.setProperty("user", "sa");
        props.setProperty("password", "");
        Connection conn = driver.connect("jdbc:h2:./db/test", props);

        conn.createStatement().execute("create table if not exists sample (name varchar(100))");
        conn.close();

        Connection conn2 = driver.connect("jdbc:h2:./db/test", props);
        conn2.createStatement().executeUpdate("insert into sample values('samile-name')");

       ResultSet rs = conn2.createStatement().executeQuery("select * from sample");
       while(rs.next())
           System.out.println(rs.getString("name"));

        conn2.close();
    }
}
