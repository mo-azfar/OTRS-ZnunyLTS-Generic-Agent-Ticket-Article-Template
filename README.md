# OTRS-ZnunyLTS-Generic-Agent-Ticket-Article-Template
- Generic Agent module that add article to ticket using existing ticket template function. (which are suporting html)  
- Built for OTRS CE v6.0.x / Znuny LTS  
  
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/MohdAzfar?locale.x=en_US)  

    Required Parameter:  
        
        Module: Kernel::System::Ticket::Event::TicketArticleTemplate
        SubjectText: This is article subject
        TemplateID: Ticket TemplateID (Admin > Templates). Expecting value: ID of the template.
        CustomerVisibility: Determine if article should be visible to customer portal. Expecting value: Yes / No.
        

        