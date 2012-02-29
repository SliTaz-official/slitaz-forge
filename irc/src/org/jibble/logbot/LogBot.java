package org.jibble.logbot;

import java.util.*;
import java.util.regex.*;
import java.io.*;
import java.text.SimpleDateFormat;
import org.jibble.pircbot.*;

public class LogBot extends PircBot {

    private static final Pattern urlPattern = Pattern.compile("(?i:\\b((http|https|ftp|irc)://[^\\s]+))");
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm");
    
    public static final String GREEN = "irc-green";
    public static final String WHITE = "irc-white";
    public static final String ORANGE = "irc-orange";
    public static final String YELLOW = "irc-yellow";
    public static final String GREY = "irc-grey";
    public static final String RED = "irc-red";
    
    public LogBot(String name, File outDir, String joinMessage) {
        setName(name);
        setVerbose(true);
        this.outDir = outDir;
        this.joinMessage = joinMessage;
    }
    
    public void append(String color, String line) {
        line = Colors.removeFormattingAndColors(line);
        
        line = line.replaceAll("&", "&amp;");
        line = line.replaceAll("<", "&lt;");
        line = line.replaceAll(">", "&gt;");
        
        Matcher matcher = urlPattern.matcher(line);
        line = matcher.replaceAll("<a href=\"$1\">$1</a>");
        
                
        try {
            Date now = new Date();
            String date = DATE_FORMAT.format(now);
            String time = TIME_FORMAT.format(now);
            File file = new File(outDir, date + ".log");
            BufferedWriter writer = new BufferedWriter(new FileWriter(file, true));
            String entry = "<span class=\"irc-date\">(" + time + ")</span> <span class=\"" + color + "\">" + line + "</span><br />";
            writer.write(entry);
            writer.newLine();
            writer.flush();
            writer.close();
        }
        catch (IOException e) {
            System.out.println("Could not write to log: " + e);
        }
    }
    
    public void onAction(String sender, String login, String hostname, String target, String action) {
        append(YELLOW, "* " + sender + " " + action);
    }
    
    public void onJoin(String channel, String sender, String login, String hostname) {
        append(GREEN, "*** " + sender + " (" + login + "@" + hostname + ") has joined " + channel);
    }
    
    public void onMessage(String channel, String sender, String login, String hostname, String message) {
        append(WHITE, "[" + sender + "] " + message);
        
        message = message.toLowerCase();
        if (message.startsWith(getNick().toLowerCase()) && message.indexOf("help") > 0) {
            sendMessage(channel, joinMessage);
        }
    }
    
    public void onMode(String channel, String sourceNick, String sourceLogin, String sourceHostname, String mode) {
        append(ORANGE, "*** " + sourceNick + " sets mode " + mode);
    }
    
    public void onNickChange(String oldNick, String login, String hostname, String newNick) {
        append(ORANGE, "*** " + oldNick + " is now known as " + newNick);
    }
    
    public void onPart(String channel, String sender, String login, String hostname) {
        append(GREY, "*** " + sender + " (" + login + "@" + hostname + ") has left " + channel);
    }

    public void onQuit(String sourceNick, String sourceLogin, String sourceHostname, String reason) {
         append(RED, "*** " + sourceNick + " (" + sourceLogin + "@" + sourceHostname + ") has quit (" + reason + ")");
    }
    
    public void onTopic(String channel, String topic, String setBy, long date, boolean changed) {
        if (changed) {
            append(GREEN, "*** " + setBy + " changes topic to '" + topic + "'");
        }
        else {
            append(GREEN, "*** Topic is '" + topic + "'");
            append(GREEN, "*** Set by " + setBy + " on " + new Date(date));
        }
    }
    
    public void onVersion(String sourceNick, String sourceLogin, String sourceHostname, String target) {
    }
    
    public void onKick(String channel, String kickerNick, String kickerLogin, String kickerHostname, String recipientNick, String reason) {
        append(GREY, "*** " + recipientNick + " was kicked from " + channel + " by " + kickerNick);
        if (recipientNick.equalsIgnoreCase(getNick())) {
            joinChannel(channel);
        }
    }
    
    public void onDisconnect() {
        append(RED, "*** Disconnected.");
        while (!isConnected()) {
            try {
                reconnect();
            }
            catch (Exception e) {
                try {
                    Thread.sleep(10000);
                }
                catch (Exception anye) {
                    // Do nothing.
                }
            }
        }
    }
    
    public static void copy(File source, File target) throws IOException {
        BufferedInputStream input = new BufferedInputStream(new FileInputStream(source));
        BufferedOutputStream output = new BufferedOutputStream(new FileOutputStream(target));
        int bytesRead = 0;
        byte[] buffer = new byte[1024];
        while ((bytesRead = input.read(buffer, 0, buffer.length)) != -1) {
            output.write(buffer, 0, bytesRead);
        }
        output.flush();
        output.close();
        input.close();
    }
    
    private File outDir;
    private String joinMessage;
    
}
