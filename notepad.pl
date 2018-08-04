#!/usr/bin/perl
use strict;
use warnings;
use Tk;

my $mw = MainWindow->new;
my $openFile="";
my $forSave="";
my $clipboard="";
my ($chars,$len,$maxlength ,$size,$var) = (0,0,0,0,0);
$mw->geometry("1300x600");
$mw->title("Text Formatter");

#-----------------Frames-----------------------#
$mw->configure(-menu => my $menubar = $mw->Menu);
my $top_frame =
  $mw->Frame( -background => 'purple' )->pack( -side => 'top', -fill => 'x' );
my $left_frame =
  $mw->Frame( -background => 'white' )->pack( -side => 'left', -fill => 'y' );
my $right_frame =
  $mw->Frame( -background => 'white' )->pack( -side => 'right', -fill => 'y' );

#----------------MenuItems-------------------------#

my $file = $menubar->cascade(-label => '~File',-tearoff=>0);
my $edit = $menubar->cascade(-label => '~Edit',-tearoff=>0,);
my $help = $menubar->cascade(-label => '~Help',-tearoff=>0,);
my $font = $mw->fontCreate(
          -size => 12,
          -weight => 'bold',
          -family => "Times 18");
my $font2 = $mw->fontCreate(
          -size => 10,
          -family => "Times 18");          
#------------Menu's-----------------------------#
my $Mode=$file->cascade(
    -label      => 'Mode',
    -tearoff=>0,
);
    
my $open=$file->command(
    -label       => 'Open',
    -accelerator => 'Ctrl-o',
    -underline   => 0,
    -command     => \&open_file,
);
$file->separator;
my $save=$file->command(
    -label       => 'Save',
    -accelerator => 'Ctrl-s',
    -underline   => 0,
    -command     => \&save_file,
);

$file->separator;
$file->command(
    -label       => "Quit",
    -underline   => 0,
    -command     => \&exit,
);


my $pref= $edit->cascade(
    -label => 'Character to use..',
    -tearoff=>0
);

my $copy=$edit->command(
    -label       => 'Copy',
    -accelerator => 'Ctrl-c',
    -underline   => 0,
    -command     => \&copyClip,
);
my $paste=$edit->command(
    -label       => 'Paste in Edit Window',
    -accelerator => 'Ctrl-v',
    -underline   => 0,
    -command     => \&pasteClip,
);

$help->command(
    -label => 'Version', 
    -command => sub {version()}
);
$help->separator;
$help->command(
    -label => 'About',  
     -command => sub {about()}
);
$help->command(
    -label => 'How to use..',  
     -command => sub {howTo()}
);

my $mode="GUI";
foreach (qw/File GUI/) {
    $Mode->radiobutton(
        -label    => $_,
        -variable => \$mode,
    );
}
my $character="-><-";
foreach (qw/-><- * # Line_Numbers/) {
    $pref->radiobutton(
        -label    => $_,
        -variable => \$character,
    );
}
#-------------Binds for shortcuts---------------------------#
$mw->bind('<Control-o>', [\&open_file]);
$mw->bind('<Control-s>', [\&save_file]);
$mw->bind('<Control-h>', [\&howTo]);
#------------Widgets--------------------------#
$top_frame->Label(
    -text => "Simple Text Formatter", 
    -background => 'cyan',
    -font=>$font,
    ) ->pack( -side => 'top' );

$left_frame->Label(
    -text       => "Enter the text here that you wish to format\n ( Or Displays the contents of file)",
    -background => 'yellow'
    )->pack( -side => 'top', -fill => 'both' );

$right_frame->Label( 
    -text => "Formatted Text\n", 
    -background => 'yellow' 
    )->pack( -side => 'top', -fill => 'both' );

my $left_text;
    
my $exitButton= 
    $left_frame->Button(
    -text => "Done", 
    -font=>$font,
    -command => sub { exit } 
    )->pack( -side => 'bottom',-fill=>'both',-expand=>1);
    
my $executeButton =
    $left_frame->Button(
    -text    => "Click here to execute formatting",
    -font=>$font,
    -command => sub { Echo($left_text); }
    )->pack( -side => 'bottom',-fill=>'both',-expand=>1);

$left_text=$left_frame->Scrolled(
	'Text',
    -height => 35, 
    -width => 89 ,
    -font=>$font2,
    -scrollbars => 'se'
    )->pack( -side => 'left', -fill => 'both',-expand=>1 );
    
my $right_output=$right_frame->Scrolled(
    'Text',
    -background => 'black',
    -foreground  => 'white',
    -height     => 40,
    -width      => 90,
    -font=>$font2,
    -insertbackground => 'black',
    -scrollbars => 'se'
    )->pack( -side => 'left',-fill=>'both',-expand=>1 );
    
MainLoop;

sub Echo {
    if ($mode eq "File")
    {
        if ($openFile eq "")
        {
            my $Error = $mw->Dialog(-title => 'Error!', 
            -bitmap=>'error',
            -text => "You selected File mode, Please select a file to open",
            )->Show();
        }
        else
        {
            echoFile();
        }
    }
    else
    {
        echoGUI(@_);
    }
}

sub about
{
    my $version = $mw->Dialog(-title => 'About..', 
    -bitmap=>'info',
   -text => "Perl Project\nBy: Ikshu Bhalla and Himanshu Kansal", 
   -buttons => [ 'Ok'])->Show();
}
sub version
{
    my $aboutUs = $mw->Dialog(-title => 'Version..', 
     -bitmap=>'info',
   -text => "Version 1.1", 
   -buttons => [ 'Ok'])->Show();
}
sub howTo
{
    my $howTo = $mw->Dialog(-title => 'How To Use...', 
    -bitmap=>'questhead',
    -text => 
"This app can be used to format text using a GUI or File\n
Use Mode (GUI/File) from the File Menu\n
Use either a bulleting character ( * , # , -> <- ) or line numbers from the Edit menu -> Character to use\n", 
   -buttons => [ 'Ok'])->Show();
}
my $types = [ ['Perl Files', '.pl'],
              ['Text Files','.txt'],
              ['All Files',   '*'],];

sub open_file {
  $openFile = $mw->getOpenFile(-filetypes => $types,
                              -defaultextension => '.txt');
}

sub save_file {
  my $save = $mw->getSaveFile(-filetypes => $types, 
                             -defaultextension => '.txt');
    open( FILE2, "+>", "$save");
    print FILE2 $forSave;
    close(FILE2);
}

sub echoFile
{
    open( FILE, "<", "$openFile");
    $right_output -> delete('1.0','end');
    $left_text -> delete('1.0','end');
    my ($size,$maxlength,$lines)=(0,0,0);
    $forSave="";
    while(<FILE>)
    {
	my $line=$_;
	$left_text->insert('end',$line);
	$lines++;
	$size+=length($line);
	$line=~s/\r|\n//g;
	my $len=length($line);
	$maxlength = $maxlength >= $len ? $maxlength:$len;
	if ($character eq '*' or $character eq '#') 
	{
            $right_output->insert('end',"$character$line$character\n");
            $forSave=$forSave."$character$line$character\n";
	}
	elsif ($character eq "-><-")
	{
	    $right_output->insert('end',"->$line<-\n");
	    $forSave=$forSave."->$line<-\n";
	}
	else
	{
	    $right_output->insert('end',"$lines $line\n");
	    $forSave=$forSave."$lines $line\n";
	}
    }
    $right_output->insert("end","\n$lines lines,longest line has $maxlength characters,$size bytes total.");
    $save="";
    close(FILE);
}

sub echoGUI
{
=my ($widget) = @_;
    my $text = $widget->Contents();
    $right_output -> delete('1.0','end');
    my ($size,$maxlength,$lines)=(0,0,0);
    my @data=split /\n/,$text;
    $forSave="";
    foreach my $line(@data)
    {
        $lines++;
	$size+=length($line);
	$line=~s/\r|\n//g;
	my $len=length($line);
	$maxlength = $maxlength >= $len ? $maxlength:$len;
	if ($character eq '*' or $character eq '#') 
	{
            $right_output->insert('end',"$character$line$character\n");
            $forSave=$forSave."$character$line$character\n";
	}
	elsif ($character eq "-><-")
	{
	    $right_output->insert('end',"->$line<-\n");
	    $forSave=$forSave."->$line<-\n";
	}
	else
	{
	    $right_output->insert('end',"$lines $line\n");
	    $forSave=$forSave."$lines $line\n";
	}
    }
    $right_output->insert("end","\n$lines lines,longest line has $maxlength characters,$size bytes total.");
    $save="";
=cut
($chars,$len,$maxlength ,$size,$var) = (0,0,0,0,0);
$right_output -> delete('1.0','end'); 
 if ($character eq '*' or $character eq '#') 
{
    $right_output->insert('end',"$character");
   $forSave=$forSave."$character";
}
elsif ($character eq "-><-")
{
 $right_output->insert('end',"->");
 $forSave="->";
}
else
{
	    $right_output->insert('end',"1");
	    $forSave=$forSave."1";
}
$left_text->bind('<Any-KeyPress>', [\&dt]);
sub dt {
  

  my $c  = $left_text->get("end - 2c","end-1c");
  $left_text->bind('<BackSpace>', 
                              sub{
                                      
                                          });
   
     $var++;
     if($c eq "\n")
     {
       $var--;
      $len = $var;
      $maxlength = $maxlength >= $len ? $maxlength : $len;
      $var = 0;
      $size++;
       if ($character eq '*' or $character eq '#') 
	{
            $right_output->insert('end',"$character\n");
            $right_output->insert('end',"$character");
            $forSave=$forSave."$character\n$character\n";
	}
	elsif ($character eq "-><-")
	{
	   $right_output->insert('end',"<-"."\n");
           $right_output->insert('end',"->");
           $forSave = $forSave."<-"."\n"."->";
	}
	else
	{
	    $right_output->insert('end',"\n");
	    my $line2 = $size+1;
	    $right_output->insert('end',"$line2");
	    $forSave=$forSave."\n"."$line2";
	}
    }
    else
    { 
     $right_output->insert('end',"$c");
     $forSave = $forSave."$c";
    }  
   $chars++;
   my $out = $right_output->Label(-textvariable => \("$size lines,longest $maxlength characters,$chars bytes total."),  -font => "Times 18")->place(-x => 0,-y => 480);
}
  
}

sub copyClip
{
    my $selection=$right_output->SelectionGet;
    $clipboard=$selection;
}
sub pasteClip
{
    $left_text->delete('1.0','end');
    $left_text->insert('end',$clipboard);
}