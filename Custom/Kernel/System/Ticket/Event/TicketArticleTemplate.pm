# --
# Copyright (C) 2021 mo-azfar, https://github.com/mo-azfar/OTRS-ZnunyLTS-Generic-Agent-Ticket-Article-Template
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
# Generic Agent module that add article to ticket using existing ticket template function. (which are suporting html)

package Kernel::System::Ticket::Event::TicketArticleTemplate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;
    
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        'Kernel::System::Log' => {
            LogPrefix => 'TicketArticleTemplate', 
        },
    );
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');
        
    # check needed param
    if ( !$Param{TicketID} || !$Param{New}->{'SubjectText'} || !$Param{New}->{'TemplateID'} || !$Param{New}->{'CustomerVisibility'} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'Need TicketID || SubjectText || TemplateID || CustomerVisibility Param and Value for this operation',
        );
        return;
    }
    
    my $TicketID = $Param{TicketID};  
    my $Subject = $Param{New}->{'SubjectText'}; 
    my $TemplateID = $Param{New}->{'TemplateID'};
    my $CustomerVisibility = $Param{New}->{'CustomerVisibility'};
    
    my $Visibility;
    if ($CustomerVisibility eq 'Yes')
    {
        $Visibility = '1';
    }
    elsif ($CustomerVisibility eq 'No')
    {
        $Visibility = '0';
    }
    else
    {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'CustomerVisibility value must be Yes or No',
        );
        return;
    }

    my $StandardTemplateObject = $Kernel::OM->Get('Kernel::System::StandardTemplate');
    my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(ChannelName => 'Internal');
    
    my %StandardTemplate = $StandardTemplateObject->StandardTemplateGet(
        ID => $TemplateID,
    );
    
    if (!%StandardTemplate)
    {
        $LogObject->Log(
            Priority => 'error',
            Message  => 'TemplateID value not found.',
        );
        return;
    }
    
    my $ArticleID = $ArticleBackendObject->ArticleCreate(
        TicketID             => $TicketID,                              
        SenderType           => 'system',                          #agent|system|customer
        IsVisibleForCustomer => $Visibility,                                
        UserID               => 1,                              
        From           => 'system',       
        Subject        => $Subject,               
        Body           => $StandardTemplate{Template},                     
        ContentType    => $StandardTemplate{ContentType},     
        HistoryType    => 'AddNote',                          
        HistoryComment => 'Add note from system',
    );
            
    return 1;
}

1;
