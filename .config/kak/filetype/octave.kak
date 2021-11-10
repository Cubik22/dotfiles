# https://www.gnu.org/software/octave
#

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](m) %{
    set-option buffer filetype octave
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=octave %{
    require-module octave

    set-option window static_words %opt{octave_static_words}

    hook window InsertChar \n -group octave-insert octave-insert-on-new-line
    hook window InsertChar \n -group octave-indent octave-indent-on-new-line
    # cleanup trailing whitespaces on current line insert end
    hook window ModeChange pop:insert:.* -group octave-trim-indent %{ try %{ execute-keys -draft <semicolon> <a-x> s ^\h+$ <ret> d } }
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window octave-.+ }
}

hook -group octave-highlight global WinSetOption filetype=octave %{
    add-highlighter window/octave ref octave
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/octave }
}

hook global BufSetOption filetype=octave %{
    set-option buffer comment_line '%'
}

provide-module octave %§

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/octave regions
add-highlighter shared/octave/code default-region group
add-highlighter shared/octave/comment region '%' '$' fill comment
add-highlighter shared/octave/line_comment region '%' '$' fill comment
add-highlighter shared/octave/documentation region '%%'  '$' fill documentation
add-highlighter shared/octave/single_string region "'"   (?<!\\)(\\\\)*'  fill string
add-highlighter shared/octave/double_string region '"'   (?<!\\)(\\\\)*"  fill string

# Integer formats
add-highlighter shared/octave/code/ regex '(?i)\b0b[01]+l?\b' 0:value
add-highlighter shared/octave/code/ regex '(?i)\b0x[\da-f]+l?\b' 0:value
add-highlighter shared/octave/code/ regex '(?i)\b0o?[0-7]+l?\b' 0:value
add-highlighter shared/octave/code/ regex '(?i)\b([1-9]\d*|0)l?\b' 0:value
# Float formats
add-highlighter shared/octave/code/ regex '\b\d+[eE][+-]?\d+\b' 0:value
add-highlighter shared/octave/code/ regex '(\b\d+)?\.\d+\b' 0:value
add-highlighter shared/octave/code/ regex '\b\d+\.' 0:value
# Imaginary formats
add-highlighter shared/octave/code/ regex '\b\d+\+\d+[jJ]\b' 0:value

add-highlighter shared/octave/code/ regex \b[a-z][A-Za-z_0-9]*(?=\.\w) 0:module
add-highlighter shared/octave/code/ regex \b[a-z][A-Za-z_0-9]*(?=__\w) 0:module
add-highlighter shared/octave/code/ regex \b[A-Z][A-Za-z_0-9]*\b 0:variable

# operator symbols
add-highlighter shared/octave/code/ regex (\.|!|!\.|!:|@|\^|:|\*\*|\\|\*|/|//|<<|>>|\+|\+\+|-|--|/\\|\\/|\.\.|:=|=\^|<|=|=\.\.|=:=|=<|==|=\\=|>|>=|@<|@=<|@>|@>=|\\=|\\==|~=|\\\+|~|<=|<=>|=>|,|&|->|\;|::|:-|\?-) 0:operator

evaluate-commands %sh{
    # Grammar
    values="true false eps Inf NaN pi NaT"

    meta="import"

	keywords="return function arguments switch case else elseif end if otherwise break continue do for while parfor spmd classdef methods properties events persistent global try catch rethrow throw"

	types="double single int8 int16 int32 int64 uint8 uint16 uint32 uint64 string char"

	attributes="Abstract AllowedSubclasses ConstructOnLoad HandleCompatible Hidden InferiorClasses Sealed AbortSet Access Constant Dependent GetAccess GetObservable NonCopyable PartialMatchPriority SetAccess SetObservable Transient"

	methods="Abstract Access Hidden Sealed Static"

	functions="acos acosd acosh acot acotd acoth acsc acscd acsch asec asecd
	asech asin asind asinh atan atan2 atand atanh cos cosd cosh cot cotd coth
	csc cscd csch hypot sec secd sech sin sind sinh tan tand tanh exp expm1 log
	log10 log1p log2 nextpow2 nthroot pow2 reallog realpow realsqrt sqrt abs
	angle complex conj cplxpair imag real sign unwrap ceil fix floor idivide
	mod rem round factor factorial gcd isprime lcm nchoosek perms primes rat
	rats conv deconv poly polyder polyeig polyfit polyint polyval polyvalm
	residue roots arrayfun cast cat class find intmax intmin intwarning ipermute
	isa isequal isequalwithequalnans isfinite isinf isnan isnumeric isreal
	isscalar isvector permute realmax realmin reshape squeeze zeros cellstr char
	eval findstr isstr regexp sprintf sscanf strcat strcmp strcmpi strings
	strjust strmatch strread strrep strtrim strvcat cell2struct deal fieldnames
	getfield isfield isstruct orderfields rmfield setfield struct struct2cell
	structfun cell cell2mat celldisp cellfun cellplot iscell iscellstr mat2cell
	num2cell feval func2str functions str2func clear depfun exist im2java inmem
	javaaddpath javaArray javachk Generate javaclasspath javaMethod javaObject
	javarmpath methodsview usejava which ischar isfloat isinteger isjava
	islogical isobject validateattributes who whos double int8 int16 int32 int64
	single typecast uint8 uint16 uint32 uint64 base2dec bin2dec hex2dec hex2num
	str2double str2num unicode2native dec2base dec2bin dec2hex int2str mat2str
	native2unicode num2str datestr logical num2hex str2mat blanks isletter
	isspace isstrprop validatestring deblank lower upper regexpi regexprep
	regexptranslate strfind strtok evalc evalin strncmp strncmpi bitand bitcmp
	bitget bitmax bitor bitset bitshift bitxor swapbytes all and any iskeyword
	isvarname not or xor dialog errordlg export2wsdlg helpdlg inputdlg listdlg
	msgbox printdlg printpreview questdlg uigetdir uigetfile uigetpref uiopen
	uiputfile uisave uisetcolor uisetfont waitbar warndlg guidata guihandles
	movegui openfig addpref getappdata getpref ginput guide inspect isappdata
	ispref rmappdata rmpref setappdata setpref uisetpref waitfor
	waitforbuttonpress uibuttongroup uicontextmenu uicontrol uimenu uipanel
	uipushtool uitoggletool uitoolbar menu findall findfigs findobj gcbf gcbo
	align getpixelposition listfonts selectmoveresize setpixelposition textwrap
	uistack uiresume uiwait box errorbar hold loglog plot plot3 plotyy polar
	semilogx semilogy subplot figurepalette pan plotbrowser plotedit plottools
	propertyeditor rotate3d showplottool zoom annotation clabel datacursormode
	datetick gtext legend line rectangle texlabel title xlabel ylabel zlabel area
	bar barh bar3 bar3h pareto pie pie3 contour contour3 contourc contourf
	ezcontour ezcontourf comet comet3 compass feather quiver quiver3 stairs stem
	stem3 ezmesh ezmeshc ezplot ezplot3 ezpolar ezsurf ezsurfc fplot hist histc
	rose convhull cylinder delaunay delaunay3 delaunayn dsearch dsearchn
	ellipsoid fill fill3 inpolygon pcolor polyarea rectint ribbon slice sphere
	tsearch tsearchn voronoi waterfall plotmatrix scatter scatter3 getframe
	im2frame movie noanimate frame2im image imagesc imfinfo imformats imread
	imwrite ind2rgb frameedit hgexport orient print printopt saveas allchild
	ancestor copyobj delete gca gco get ishandle propedit set axes figure hggroup
	hgtransform light patch surface text clf close closereq drawnow gcf hgload
	hgsave newplot opengl refresh axis cla grid ishold makehgtform linkaxes
	linkprop refreshdata brush cumprod cumsum linkdata prod sort sortrows sum
	corrcoef cov max mean median min mode std var conv2 convn detrend filter
	filter2 interp1 interp2 interp3 interpn mldivide mrdivide fft fft2 fftn
	fftshift fftw ifft ifft2 ifftn ifftshift cumtrapz del2 diff gradient trapz
	cd copyfile dir fileattrib filebrowser isdir lookfor ls matlabroot mkdir
	movefile pwd recycle rehash rmdir toolboxdir type what clipboard computer
	dos getenv hostid maxNumCompThreads perl setenv system unix winqueryreg ismac
	ispc isstudent isunix javachk license prefdir usejava ver verLessThan version
	disp display isempty issparse length ndims numel size blkdiag diag eye
	freqspace ind2sub linspace logspace meshgrid ndgrid ones rand randn sub2ind
	accumarray bsxfun cross dot kron tril triu circshift flipdim fliplr flipud
	horzcat inline repmat rot90 shiftdim vectorize vertcat compan gallery
	hadamard hankel hilb invhilb magic pascal rosser toeplitz vander wilkinson
	cond condeig det norm normest null orth rank rcond rref subspace trace chol
	cholinc condest funm ilu inv linsolve lscov lsqnonneg lu luinc pinv qr
	balance cdf2rdf eig eigs gsvd hess ordeig ordqz ordschur rsf2csf schur sqrtm
	ss2tf svd svds expm logm cholupdate planerot qrdelete qrinsert qrupdate qz
	griddata griddata3 griddatan interp1q interpft mkpp padecoef pchip ppval
	spline unmkpp tetramesh trimesh triplot trisurf convhulln voronoin cart2pol
	cart2sph pol2cart sph2cart decic deval ode15i ode23 ode45 ode113 ode15s
	ode23s ode23t ode23tb odefile odeget odeset odextend dde23 ddeget ddesd
	ddeset bvp4c bvp5c bvpget bvpinit bvpset bvpxtend pdepe pdeval fminbnd
	fminsearch fzero optimget optimset dblquad quad quadgk quadl quadv triplequad
	airy besselh besseli besselj besselk bessely beta betainc betaln ellipj
	ellipke erf erfc erfcx erfinv erfcinv expint gamma gammainc gammaln legendre
	psi spdiags speye sprand sprandn sprandsym full sparse spconvert nnz nonzeros
	nzmax spalloc spfun spones spparms spy amd colamd colperm dmperm ldl randperm
	symamd symrcm spaugment sprank bicg bicgstab cgs gmres lsqr minres pcg qmr
	symmlq etree etreeplot gplot symbfact treelayout treeplot getdatasamplesize
	getqualitydesc timeseries tsprops tstool addsample ctranspose delsample
	getabstime getinterpmethod getsampleusingtime idealfilter resample setabstime
	setinterpmethod synchronize transpose addevent delevent gettsafteratevent
	gettsafterevent gettsatevent gettsbeforeatevent gettsbeforeevent
	gettsbetweenevents iqr tscollection addsampletocollection addts
	delsamplefromcollection gettimeseriesnames removets settimeseriesnames
	intersect ismember issorted setdiff setxor union unique addtodate calendar
	clock cputime date datenum datevec eomday etime now weekday addOptional
	addParamValue addRequired createCopy depdir echo input inputname inputParser
	mfilename namelengthmax nargchk nargin nargout nargoutchk parse pcode
	varargin varargout ans assert builtin pause run script symvar isvalid start
	startat stop timer timerfind timerfindall wait assignin datatipinfo
	genvarname isglobal memory mislocked mlock munlock pack addCause error ferror
	getReport last lasterr lasterror lastwarn warning addlistener addprop
	dynamicprops findprop getdisp handle hgsetget inferiorto loadobj metaclass
	notify saveobj setdisp subsasgn subsindex subsref substruct superiorto
	filemarker fileparts filesep fullfile tempdir tempname daqread filehandle
	importdata load open save uiimport winopen memmapfile fclose feof fgetl fgets
	fopen fprintf fread frewind fscanf fseek ftell fwrite csvread csvwrite
	dlmread dlmwrite textread textscan xmlread xmlwrite xslt xlsfinfo xlsread
	xlswrite wk1finfo wk1read wk1write cdfepoch cdfinfo cdfread cdfwrite
	todatenum fitsinfo fitsread hdf hdf5 hdf5info hdf5read hdf5write hdfinfo
	hdfread hdftool multibandread multibandwrite"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list octave_static_words $(join "${values} ${meta} ${keywords} ${types} ${attributes} ${methods} ${functions}" ' ')"

    # Highlight keywords
    printf %s "
        add-highlighter shared/octave/code/ regex '\b($(join "${values}" '|'))\b' 0:value
        add-highlighter shared/octave/code/ regex '\b($(join "${meta}" '|'))\b' 0:meta
        add-highlighter shared/octave/code/ regex '\b($(join "${keywords} ${soft_keywords}" '|'))\b' 0:keyword
        add-highlighter shared/octave/code/ regex '\b($(join "${types}" '|'))\b' 0:type
        add-highlighter shared/octave/code/ regex '\b($(join "${attributes}" '|'))\b' 0:attribute
        add-highlighter shared/octave/code/ regex '\bdef\s+($(join "${methods}" '|'))\b' 1:builtin
        add-highlighter shared/octave/code/ regex '\b($(join "${functions}" '|'))\b\(' 1:function
        add-highlighter shared/octave/code/ regex '^\h*(@[\w_.]+))' 1:attribute
    "
}

# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden octave-insert-on-new-line %{
    evaluate-commands -draft -itersel %{
        # copy '%' comment prefix and following white spaces
        try %{ execute-keys -draft k <a-x> s ^\h*\%\h* <ret> y gh j P }
    }
}

define-command -hidden octave-indent-on-char %<
    evaluate-commands -draft -itersel %<
        # align closer token to its opener when alone on a line
        try %/ execute-keys -draft <a-h> <a-k> ^\h+[]}]$ <ret> m s \A|.\z <ret> 1<a-&> /
    >
>

define-command -hidden octave-indent-on-new-line %<
    evaluate-commands -draft -itersel %<
        # preserve previous line indent
	    try %{ execute-keys -draft <semicolon> K <a-&> }
        # cleanup trailing whitespaces from previous line
        try %{ execute-keys -draft k <a-x> s \h+$ <ret> d }
        # indent after line ending with :-
        try %{ execute-keys -draft <space> k <a-x> <a-k> :-$ <ret> j <a-gt> }
        # deindent closing brace/bracket when after cursor
        try %< execute-keys -draft <a-x> <a-k> ^\h*[}\])] <ret> gh / [}\])] <ret> m <a-S> 1<a-&> >
    >
>

§
