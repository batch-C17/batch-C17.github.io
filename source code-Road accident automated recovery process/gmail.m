mail = 'haritest69@gmail.com'; % my gmail address
password = 'Hari123456';  % my gmail password 
host = 'smtp.gmail.com';
sendto = 'harilive@infogrotech.com';
Subject = 'test subject';
Message = 'test message';
% preferences
setpref('Internet','SMTP_Server', host);
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% execute
sendmail(sendto,Subject,Message)