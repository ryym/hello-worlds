package hello.h2;

import java.sql.*;
import java.nio.file.*;
import java.util.Properties;

/**
 * Using h2 database.
 */
public class Main {
    public static void main(String[] a) throws Exception {
        useH2();
    }

    static String readFile(Path path) throws Exception {
        byte[] bytes = Files.readAllBytes(path);
        return new String(bytes, "utf-8");
    }

    static void useH2() throws Exception {
        Driver driver = (Driver)Class.forName("org.h2.Driver").newInstance();

        // Connect an existing database.
        // Connection conn = DriverManager.getConnection("jdbc:h2:./test", "sa", "");

        // Create in-memory database.
        Properties props = new Properties();
        props.setProperty("user", "sa");
        props.setProperty("password", "");
        Connection conn = driver.connect("jdbc:h2:mem:test", props);

        Statement stmt = conn.createStatement();

        try (DirectoryStream<Path> ds = Files.newDirectoryStream(Paths.get("./ddl"))) {
            for (Path path : ds) {
                String createTableSql = readFile(path);
                stmt.executeUpdate(createTableSql);
            }
        }

        ResultSet rs = null;
        rs = stmt.executeQuery("select * from information_schema.tables where table_type = 'TABLE'");
        while(rs.next()) {
            System.out.println(rs.getString("table_name"));
        }

        conn.setAutoCommit(false);
        stmt.executeUpdate("insert into gender values ('1', 'taro')");
        stmt.executeUpdate("insert into gender values ('2', 'hana')");
        rs = stmt.executeQuery("select * from gender");
        System.out.println("uncommitted connection ----------");
        while(rs.next()) {
        	System.out.println(rs.getString("gender_name"));
        }
        // conn.commit();

        // Other connections can't see uncommitted changes.
        Connection conn2 = driver.connect("jdbc:h2:mem:test", props);
        rs = conn2.createStatement().executeQuery("select * from gender");
        System.out.println("another connection ----------");
        while(rs.next()) {
            System.out.println(rs.getString("gender_name"));
        }

       conn.rollback();
       System.out.println("rollbacked connection ----------");
       rs = stmt.executeQuery("select * from gender");
       while(rs.next()) {
         System.out.println(rs.getString("gender_name"));
       }

        stmt.close();
        conn.close();
    }
}
