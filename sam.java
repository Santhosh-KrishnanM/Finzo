import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;

public class CableTVManagement {
    private static Connection connection;
    private static String userRole;

    public static void main(String[] args) {
        connectToDatabase();
        loginScreen();
    }

    // Database Connectivity
    private static void connectToDatabase() {
        String jdbcURL = "jdbc:oracle:thin:@localhost:1521:xe";
        String username = "sqlplus / as sysdba";
        String password = "20224207";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection(jdbcURL, username, password);
            System.out.println("Connected to Oracle database!");
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Failed to connect to the database.");
        }
    }

    // Login Screen
    private static void loginScreen() {
        JFrame frame = new JFrame("Cable TV Management Login");
        frame.setSize(400, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new GridLayout(3, 2));

        JLabel userIdLabel = new JLabel("User ID:");
        JTextField userIdField = new JTextField();
        JLabel userNameLabel = new JLabel("User Name:");
        JTextField userNameField = new JTextField();
        JButton loginButton = new JButton("Login");

        frame.add(userIdLabel);
        frame.add(userIdField);
        frame.add(userNameLabel);
        frame.add(userNameField);
        frame.add(new JLabel());
        frame.add(loginButton);

        loginButton.addActionListener(e -> {
            String userId = userIdField.getText();
            String userName = userNameField.getText();
            if (authenticateUser(userId, userName)) {
                frame.dispose();
                showDashboard();
            } else {
                JOptionPane.showMessageDialog(frame, "Invalid User ID or User Name");
            }
        });

        frame.setVisible(true);
    }

    // Authenticate User
    private static boolean authenticateUser(String userId, String userName) {
        try {
            String query = "SELECT ROLE FROM user_table WHERE USER_ID = ? AND USER_NAME = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(userId));
            ps.setString(2, userName);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                userRole = rs.getString("ROLE");
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Dashboard Screen
    private static void showDashboard() {
        JFrame frame = new JFrame("Cable TV Management Dashboard - Role: " + userRole);
        frame.setSize(600, 400);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new GridLayout(2, 2));

        JButton insertButton = new JButton("Insert Channel");
        JButton updateButton = new JButton("Update Channel");
        JButton deleteButton = new JButton("Delete Channel");
        JButton viewButton = new JButton("View Channels");

        frame.add(insertButton);
        frame.add(updateButton);
        frame.add(deleteButton);
        frame.add(viewButton);

        // Role-based access control
        if (!userRole.equalsIgnoreCase("Admin")) {
            insertButton.setEnabled(false);
            updateButton.setEnabled(false);
            deleteButton.setEnabled(false);
        }

        insertButton.addActionListener(e -> insertChannel());
        updateButton.addActionListener(e -> updateChannel());
        deleteButton.addActionListener(e -> deleteChannel());
        viewButton.addActionListener(e -> viewChannels());

        frame.setVisible(true);
    }

    // Insert Channel
    private static void insertChannel() {
        JFrame frame = new JFrame("Insert Channel");
        frame.setSize(400, 300);
        frame.setLayout(new GridLayout(5, 2));

        JLabel channelIdLabel = new JLabel("Channel ID:");
        JTextField channelIdField = new JTextField();
        JLabel channelNameLabel = new JLabel("Channel Name:");
        JTextField channelNameField = new JTextField();
        JLabel priceLabel = new JLabel("Price:");
        JTextField priceField = new JTextField();
        JButton insertButton = new JButton("Insert");

        frame.add(channelIdLabel);
        frame.add(channelIdField);
        frame.add(channelNameLabel);
        frame.add(channelNameField);
        frame.add(priceLabel);
        frame.add(priceField);
        frame.add(new JLabel());
        frame.add(insertButton);

        insertButton.addActionListener(e -> {
            try {
                String query = "INSERT INTO channel (CHANNEL_ID, CHANNEL_NAME, PRICE) VALUES (?, ?, ?)";
                PreparedStatement ps = connection.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(channelIdField.getText()));
                ps.setString(2, channelNameField.getText());
                ps.setDouble(3, Double.parseDouble(priceField.getText()));
                ps.executeUpdate();
                JOptionPane.showMessageDialog(frame, "Channel inserted successfully!");
                frame.dispose();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(frame, "Failed to insert channel.");
            }
        });

        frame.setVisible(true);
    }

    // Update Channel
    private static void updateChannel() {
        JFrame frame = new JFrame("Update Channel");
        frame.setSize(400, 300);
        frame.setLayout(new GridLayout(5, 2));

        JLabel channelIdLabel = new JLabel("Channel ID:");
        JTextField channelIdField = new JTextField();
        JLabel newPriceLabel = new JLabel("New Price:");
        JTextField newPriceField = new JTextField();
        JButton updateButton = new JButton("Update");

        frame.add(channelIdLabel);
        frame.add(channelIdField);
        frame.add(newPriceLabel);
        frame.add(newPriceField);
        frame.add(new JLabel());
        frame.add(updateButton);

        updateButton.addActionListener(e -> {
            try {
                String query = "UPDATE channel SET PRICE = ? WHERE CHANNEL_ID = ?";
                PreparedStatement ps = connection.prepareStatement(query);
                ps.setDouble(1, Double.parseDouble(newPriceField.getText()));
                ps.setInt(2, Integer.parseInt(channelIdField.getText()));
                ps.executeUpdate();
                JOptionPane.showMessageDialog(frame, "Channel updated successfully!");
                frame.dispose();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(frame, "Failed to update channel.");
            }
        });

        frame.setVisible(true);
    }

    // Delete Channel
    private static void deleteChannel() {
        JFrame frame = new JFrame("Delete Channel");
        frame.setSize(400, 200);
        frame.setLayout(new GridLayout(3, 2));

        JLabel channelIdLabel = new JLabel("Channel ID:");
        JTextField channelIdField = new JTextField();
        JButton deleteButton = new JButton("Delete");

        frame.add(channelIdLabel);
        frame.add(channelIdField);
        frame.add(new JLabel());
        frame.add(deleteButton);

        deleteButton.addActionListener(e -> {
            try {
                String query = "DELETE FROM channel WHERE CHANNEL_ID = ?";
                PreparedStatement ps = connection.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(channelIdField.getText()));
                ps.executeUpdate();
                JOptionPane.showMessageDialog(frame, "Channel deleted successfully!");
                frame.dispose();
            } catch (Exception ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(frame, "Failed to delete channel.");
            }
        });

        frame.setVisible(true);
    }

    // View Channels
    private static void viewChannels() {
        JFrame frame = new JFrame("View Channels");
        frame.setSize(600, 400);
        frame.setLayout(new BorderLayout());

        JTextArea textArea = new JTextArea();
        textArea.setEditable(false);
        frame.add(new JScrollPane(textArea), BorderLayout.CENTER);

        try {
            String query = "SELECT * FROM channel";
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                textArea.append("Channel ID: " + rs.getInt("CHANNEL_ID") +
                        ", Name: " + rs.getString("CHANNEL_NAME") +
                        ", Price: " + rs.getDouble("PRICE") + "\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(frame, "Failed to retrieve channels.");
        }

        frame.setVisible(true);
    }
}
