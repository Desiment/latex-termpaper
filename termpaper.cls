\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{termpaper}[2026/01/06 MatMex LaTeX Term Paper Class]

% ============================================================================
% DEFAULT CONFIGURATION
% ============================================================================
\def\termpaper@fontsize{12pt}       % Default font size
\def\termpaper@baseclass{article}   % Default base class

% ============================================================================
% TITLE PAGE CONFIGURATION COMMANDS
% (These can be redefined by the 14pt option)
% ============================================================================
\NewDocumentCommand\SetupTitlePage{}{} % Called before title page
\NewDocumentCommand\SetupBodyPage{}{}  % Called after title page

% ============================================================================
% PACKAGE REQUIREMENTS
% ============================================================================
\RequirePackage{xparse}    % Enhanced command definitions
\RequirePackage{kvoptions} % Key-value options
\RequirePackage{luaboolean}% Lua boolean utilities
\RequirePackage{fontswitch}% Dynamic font size switching

% ============================================================================
% CLASS OPTIONS
% ============================================================================
\SetupKeyvalOptions{prefix=termpaper@}
\DeclareStringOption[{title/records-template.lua}]{titleconf}     % Filename for title configuration


% Option: 14pt
% Switches to 14pt font size with extarticle base class
\DeclareOption{14pt}{%
  % Use extarticle class to support 14pt font size
  \def\termpaper@fontsize{14pt}%
  \def\termpaper@baseclass{extarticle}%
  
  % Title page uses 12pt font for proper layout
  \RenewDocumentCommand\SetupTitlePage{}{%
    \SetPageFontSize{12}%
  }%
  
  % Body text uses requested 14pt font
  \RenewDocumentCommand\SetupBodyPage{}{%
    \SetPageFontSize{14}%
  }%
}

% Process all class options
\ProcessKeyvalOptions*           % Process the options
\ProcessOptions\relax

% ============================================================================
% LOAD BASE CLASS WITH CONFIGURED OPTIONS
% ============================================================================
\LoadClass[a4paper,\termpaper@fontsize]{\termpaper@baseclass}

% ============================================================================
% LOCALIZATION & TYPOGRAPHY SETUP
% ============================================================================
\RequirePackage{fontspec}
\setmainfont{CMU Serif}
\setsansfont{CMU Sans Serif}
\setmonofont{CMU Typewriter Text}
%\setmonofont{Fira Code}[Contextuals=Alternate,Scale=0.9]
%\setmonofont{Inconsolata}

\RequirePackage{polyglossia}
\setmainlanguage{russian}
\setotherlanguage{english}

% Smart quotes based on current language
\RequirePackage[autostyle]{csquotes}

% ============================================================================
% PAGE LAYOUT
% ============================================================================
\RequirePackage[a4paper]{geometry}  % Page dimensions and margins
\RequirePackage{fancyhdr}           % Header/footer customization
\RequirePackage{setspace}           % Line spacing control

% ============================================================================
% TITLE CONFIGURATION LOADING
% Reads title configuration from Lua file (default: title.lua)
% Custom path can be specified via class option: title={custom/path.lua}
% ============================================================================
\directlua{titleconf = require('title.lua').readconf('\termpaper@titleconf')}

% ============================================================================
% LOAD TITLE PAGE TEMPLATE
% ============================================================================
\input{title/base.tex}

% ============================================================================
% TYPOGRAPHIC ADJUSTMENTS
% ============================================================================
\setdisplayskipstretch{1.0}  % Control spacing around displayed math
