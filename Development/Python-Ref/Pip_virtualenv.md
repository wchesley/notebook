[back](./README.md)

# Pip Virtualenv


<h1>Installing packages using pip and virtual environments<a class="headerlink" href="#installing-packages-using-pip-and-virtual-environments" title="Permalink to this headline">¶</a></h1>
<p>This guide discusses how to install packages using <a class="reference internal" href="../../key_projects/#pip"><span class="std std-ref">pip</span></a> and
a virtual environment manager: either <a class="reference internal" href="../../key_projects/#venv"><span class="std std-ref">venv</span></a> for Python 3 or <a class="reference internal" href="../../key_projects/#virtualenv"><span class="std std-ref">virtualenv</span></a>
for Python 2. These are the lowest-level tools for managing Python
packages and are recommended if higher-level tools do not suit your needs.</p>
<div class="admonition note">
<p class="admonition-title">Note</p>
<p>This doc uses the term <strong>package</strong> to refer to a
<a class="reference internal" href="../../glossary/#term-Distribution-Package"><span class="xref std std-term">Distribution Package</span></a>  which is different from an <a class="reference internal" href="../../glossary/#term-Import-Package"><span class="xref std std-term">Import
Package</span></a> that which is used to import modules in your Python source code.</p>
</div>
<section id="installing-pip">
<h2>Installing pip<a class="headerlink" href="#installing-pip" title="Permalink to this headline">¶</a></h2>
<p><a class="reference internal" href="../../key_projects/#pip"><span class="std std-ref">pip</span></a> is the reference Python package manager. It’s used to install and
update packages. You’ll need to make sure you have the latest version of pip
installed.</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--0-input--1" name="tab-set--0" type="radio"><label class="tab-label" for="tab-set--0-input--1">Unix/macOS</label><div class="tab-content docutils container">
<p>Debian and most other distributions include a <a class="reference external" href="https://packages.debian.org/stable/python/python3-pip">python-pip</a> package; if you
want to use the Linux distribution-provided versions of pip, see
<a class="reference internal" href="../installing-using-linux-tools/"><span class="doc">Installing pip/setuptools/wheel with Linux Package Managers</span></a>.</p>
<p>You can also install pip yourself to ensure you have the latest version. It’s
recommended to use the system pip to bootstrap a user installation of pip:</p>
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell0"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--user<span class="w"> </span>--upgrade<span class="w"> </span>pip

python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>--version
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell0">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>Afterwards, you should have the latest version of pip installed in your
user site:</p>
<div class="highlight-text notranslate"><div class="highlight"><pre id="codecell1"><span></span>pip 21.1.3 from $HOME/.local/lib/python3.9/site-packages (python 3.9)
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell1">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--0-input--2" name="tab-set--0" type="radio"><label class="tab-label" for="tab-set--0-input--2">Windows</label><div class="tab-content docutils container">
<p>The Python installers for Windows include pip. You can make sure that pip is
up-to-date by running:</p>
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell2"><span></span>py -m pip install --upgrade pip

py -m pip --version
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell2">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>Afterwards, you should have the latest version of pip:</p>
<div class="highlight-text notranslate"><div class="highlight"><pre id="codecell3"><span></span>pip 21.1.3 from c:\python39\lib\site-packages (Python 3.9.4)
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell3">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="installing-virtualenv">
<h2>Installing virtualenv<a class="headerlink" href="#installing-virtualenv" title="Permalink to this headline">¶</a></h2>
<div class="admonition note">
<p class="admonition-title">Note</p>
<p>If you are using Python 3.3 or newer, the <a class="reference external" href="https://docs.python.org/3/library/venv.html#module-venv" title="(in Python v3.11)"><code class="xref py py-mod docutils literal notranslate"><span class="pre">venv</span></code></a> module is
the preferred way to create and manage virtual environments.
venv is included in the Python standard library and requires no additional installation.
If you are using venv, you may skip this section.</p>
</div>
<p><a class="reference internal" href="../../key_projects/#virtualenv"><span class="std std-ref">virtualenv</span></a> is used to manage Python packages for different projects.
Using virtualenv allows you to avoid installing Python packages globally
which could break system tools or other projects. You can install virtualenv
using pip.</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--1-input--1" name="tab-set--1" type="radio"><label class="tab-label" for="tab-set--1-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell4"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--user<span class="w"> </span>virtualenv
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell4">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--1-input--2" name="tab-set--1" type="radio"><label class="tab-label" for="tab-set--1-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell5"><span></span>py -m pip install --user virtualenv
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell5">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="creating-a-virtual-environment">
<h2>Creating a virtual environment<a class="headerlink" href="#creating-a-virtual-environment" title="Permalink to this headline">¶</a></h2>
<p><a class="reference internal" href="../../key_projects/#venv"><span class="std std-ref">venv</span></a> (for Python 3) and <a class="reference internal" href="../../key_projects/#virtualenv"><span class="std std-ref">virtualenv</span></a> (for Python 2) allow
you to manage separate package installations for
different projects. They essentially allow you to create a “virtual” isolated
Python installation and install packages into that virtual installation. When
you switch projects, you can simply create a new virtual environment and not
have to worry about breaking the packages installed in the other environments.
It is always recommended to use a virtual environment while developing Python
applications.</p>
<p>To create a virtual environment, go to your project’s directory and run
venv. If you are using Python 2, replace <code class="docutils literal notranslate"><span class="pre">venv</span></code> with <code class="docutils literal notranslate"><span class="pre">virtualenv</span></code>
in the below commands.</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--2-input--1" name="tab-set--2" type="radio"><label class="tab-label" for="tab-set--2-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell6"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>venv<span class="w"> </span>env
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell6">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--2-input--2" name="tab-set--2" type="radio"><label class="tab-label" for="tab-set--2-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell7"><span></span>py -m venv env
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell7">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>The second argument is the location to create the virtual environment. Generally, you
can just create this in your project and call it <code class="docutils literal notranslate"><span class="pre">env</span></code>.</p>
<p>venv will create a virtual Python installation in the <code class="docutils literal notranslate"><span class="pre">env</span></code> folder.</p>
<div class="admonition note">
<p class="admonition-title">Note</p>
<p>You should exclude your virtual environment directory from your version
control system using <code class="docutils literal notranslate"><span class="pre">.gitignore</span></code> or similar.</p>
</div>
</section>
<section id="activating-a-virtual-environment">
<h2>Activating a virtual environment<a class="headerlink" href="#activating-a-virtual-environment" title="Permalink to this headline">¶</a></h2>
<p>Before you can start installing or using packages in your virtual environment you’ll
need to <em>activate</em> it. Activating a virtual environment will put the
virtual environment-specific
<code class="docutils literal notranslate"><span class="pre">python</span></code> and <code class="docutils literal notranslate"><span class="pre">pip</span></code> executables into your shell’s <code class="docutils literal notranslate"><span class="pre">PATH</span></code>.</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--3-input--1" name="tab-set--3" type="radio"><label class="tab-label" for="tab-set--3-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell8"><span></span><span class="nb">source</span><span class="w"> </span>env/bin/activate
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell8">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--3-input--2" name="tab-set--3" type="radio"><label class="tab-label" for="tab-set--3-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell9"><span></span>.\env\Scripts\activate
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell9">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>You can confirm you’re in the virtual environment by checking the location of your
Python interpreter:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--4-input--1" name="tab-set--4" type="radio"><label class="tab-label" for="tab-set--4-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell10"><span></span>which<span class="w"> </span>python
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell10">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--4-input--2" name="tab-set--4" type="radio"><label class="tab-label" for="tab-set--4-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell11"><span></span>where python
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell11">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>It should be in the <code class="docutils literal notranslate"><span class="pre">env</span></code> directory:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--5-input--1" name="tab-set--5" type="radio"><label class="tab-label" for="tab-set--5-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell12"><span></span>.../env/bin/python
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell12">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--5-input--2" name="tab-set--5" type="radio"><label class="tab-label" for="tab-set--5-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell13"><span></span>...\env\Scripts\python.exe
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell13">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>As long as your virtual environment is activated pip will install packages into that
specific environment and you’ll be able to import and use packages in your
Python application.</p>
</section>
<section id="leaving-the-virtual-environment">
<h2>Leaving the virtual environment<a class="headerlink" href="#leaving-the-virtual-environment" title="Permalink to this headline">¶</a></h2>
<p>If you want to switch projects or otherwise leave your virtual environment, simply run:</p>
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell14"><span></span>deactivate
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell14">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>If you want to re-enter the virtual environment just follow the same instructions above
about activating a virtual environment. There’s no need to re-create the virtual environment.</p>
</section>
<section id="installing-packages">
<h2>Installing packages<a class="headerlink" href="#installing-packages" title="Permalink to this headline">¶</a></h2>
<p>Now that you’re in your virtual environment you can install packages. Let’s install the
<a class="reference external" href="https://pypi.org/project/requests/">Requests</a> library from the <a class="reference internal" href="../../glossary/#term-Python-Package-Index-PyPI"><span class="xref std std-term">Python Package Index (PyPI)</span></a>:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--6-input--1" name="tab-set--6" type="radio"><label class="tab-label" for="tab-set--6-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell15"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell15">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--6-input--2" name="tab-set--6" type="radio"><label class="tab-label" for="tab-set--6-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell16"><span></span>py -m pip install requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell16">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>pip should download requests and all of its dependencies and install them:</p>
<div class="highlight-text notranslate"><div class="highlight"><pre id="codecell17"><span></span>Collecting requests
  Using cached requests-2.18.4-py2.py3-none-any.whl
Collecting chardet&lt;3.1.0,&gt;=3.0.2 (from requests)
  Using cached chardet-3.0.4-py2.py3-none-any.whl
Collecting urllib3&lt;1.23,&gt;=1.21.1 (from requests)
  Using cached urllib3-1.22-py2.py3-none-any.whl
Collecting certifi&gt;=2017.4.17 (from requests)
  Using cached certifi-2017.7.27.1-py2.py3-none-any.whl
Collecting idna&lt;2.7,&gt;=2.5 (from requests)
  Using cached idna-2.6-py2.py3-none-any.whl
Installing collected packages: chardet, urllib3, certifi, idna, requests
Successfully installed certifi-2017.7.27.1 chardet-3.0.4 idna-2.6 requests-2.18.4 urllib3-1.22
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell17">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</section>
<section id="installing-specific-versions">
<h2>Installing specific versions<a class="headerlink" href="#installing-specific-versions" title="Permalink to this headline">¶</a></h2>
<p>pip allows you to specify which version of a package to install using
<a class="reference internal" href="../../glossary/#term-Version-Specifier"><span class="xref std std-term">version specifiers</span></a>. For example, to install
a specific version of <code class="docutils literal notranslate"><span class="pre">requests</span></code>:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--7-input--1" name="tab-set--7" type="radio"><label class="tab-label" for="tab-set--7-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell18"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span><span class="s1">'requests==2.18.4'</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell18">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--7-input--2" name="tab-set--7" type="radio"><label class="tab-label" for="tab-set--7-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell19"><span></span>py -m pip install <span class="s2">"requests==2.18.4"</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell19">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>To install the latest <code class="docutils literal notranslate"><span class="pre">2.x</span></code> release of requests:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--8-input--1" name="tab-set--8" type="radio"><label class="tab-label" for="tab-set--8-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell20"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span><span class="s1">'requests&gt;=2.0.0,&lt;3.0.0'</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell20">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--8-input--2" name="tab-set--8" type="radio"><label class="tab-label" for="tab-set--8-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell21"><span></span>py -m pip install <span class="s2">"requests&gt;=2.0.0,&lt;3.0.0"</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell21">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>To install pre-release versions of packages, use the <code class="docutils literal notranslate"><span class="pre">--pre</span></code> flag:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--9-input--1" name="tab-set--9" type="radio"><label class="tab-label" for="tab-set--9-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell22"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--pre<span class="w"> </span>requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell22">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--9-input--2" name="tab-set--9" type="radio"><label class="tab-label" for="tab-set--9-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell23"><span></span>py -m pip install --pre requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell23">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="installing-extras">
<h2>Installing extras<a class="headerlink" href="#installing-extras" title="Permalink to this headline">¶</a></h2>
<p>Some packages have optional <a class="reference external" href="https://setuptools.readthedocs.io/en/latest/userguide/dependency_management.html#optional-dependencies">extras</a>. You can tell pip to install these by
specifying the extra in brackets:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--10-input--1" name="tab-set--10" type="radio"><label class="tab-label" for="tab-set--10-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell24"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span><span class="s1">'requests[security]'</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell24">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--10-input--2" name="tab-set--10" type="radio"><label class="tab-label" for="tab-set--10-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell25"><span></span>py -m pip install <span class="s2">"requests[security]"</span>
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell25">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="installing-from-source">
<h2>Installing from source<a class="headerlink" href="#installing-from-source" title="Permalink to this headline">¶</a></h2>
<p>pip can install a package directly from source, for example:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--11-input--1" name="tab-set--11" type="radio"><label class="tab-label" for="tab-set--11-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell26"><span></span><span class="nb">cd</span><span class="w"> </span>google-auth
python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>.
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell26">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--11-input--2" name="tab-set--11" type="radio"><label class="tab-label" for="tab-set--11-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell27"><span></span><span class="k">cd</span> google-auth
py -m pip install .
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell27">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>Additionally, pip can install packages from source in
<a class="reference external" href="https://setuptools.pypa.io/en/latest/userguide/development_mode.html" title="(in setuptools v67.6.1.post20230328)"><span class="xref std std-doc">development mode</span></a>,
meaning that changes to the source directory will immediately affect the
installed package without needing to re-install:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--12-input--1" name="tab-set--12" type="radio"><label class="tab-label" for="tab-set--12-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell28"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--editable<span class="w"> </span>.
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell28">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--12-input--2" name="tab-set--12" type="radio"><label class="tab-label" for="tab-set--12-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell29"><span></span>py -m pip install --editable .
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell29">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="installing-from-version-control-systems">
<h2>Installing from version control systems<a class="headerlink" href="#installing-from-version-control-systems" title="Permalink to this headline">¶</a></h2>
<p>pip can install packages directly from their version control system. For
example, you can install directly from a git repository:</p>
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell30"><span></span>google-auth<span class="w"> </span>@<span class="w"> </span>git+https://github.com/GoogleCloudPlatform/google-auth-library-python.git
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell30">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>For more information on supported version control systems and syntax, see pip’s
documentation on <a class="reference external" href="https://pip.pypa.io/en/latest/topics/vcs-support/#vcs-support" title="(in pip v23.1)"><span class="xref std std-ref">VCS Support</span></a>.</p>
</section>
<section id="installing-from-local-archives">
<h2>Installing from local archives<a class="headerlink" href="#installing-from-local-archives" title="Permalink to this headline">¶</a></h2>
<p>If you have a local copy of a <a class="reference internal" href="../../glossary/#term-Distribution-Package"><span class="xref std std-term">Distribution Package</span></a>’s archive (a zip,
wheel, or tar file) you can install it directly with pip:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--13-input--1" name="tab-set--13" type="radio"><label class="tab-label" for="tab-set--13-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell31"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>requests-2.18.4.tar.gz
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell31">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--13-input--2" name="tab-set--13" type="radio"><label class="tab-label" for="tab-set--13-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell32"><span></span>py -m pip install requests-2.18.4.tar.gz
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell32">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>If you have a directory containing archives of multiple packages, you can tell
pip to look for packages there and not to use the
<a class="reference internal" href="../../glossary/#term-Python-Package-Index-PyPI"><span class="xref std std-term">Python Package Index (PyPI)</span></a> at all:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--14-input--1" name="tab-set--14" type="radio"><label class="tab-label" for="tab-set--14-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell33"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--no-index<span class="w"> </span>--find-links<span class="o">=</span>/local/dir/<span class="w"> </span>requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell33">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--14-input--2" name="tab-set--14" type="radio"><label class="tab-label" for="tab-set--14-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell34"><span></span>py -m pip install --no-index --find-links=/local/dir/ requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell34">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>This is useful if you are installing packages on a system with limited
connectivity or if you want to strictly control the origin of distribution
packages.</p>
</section>
<section id="using-other-package-indexes">
<h2>Using other package indexes<a class="headerlink" href="#using-other-package-indexes" title="Permalink to this headline">¶</a></h2>
<p>If you want to download packages from a different index than the
<a class="reference internal" href="../../glossary/#term-Python-Package-Index-PyPI"><span class="xref std std-term">Python Package Index (PyPI)</span></a>, you can use the <code class="docutils literal notranslate"><span class="pre">--index-url</span></code> flag:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--15-input--1" name="tab-set--15" type="radio"><label class="tab-label" for="tab-set--15-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell35"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--index-url<span class="w"> </span>http://index.example.com/simple/<span class="w"> </span>SomeProject
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell35">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--15-input--2" name="tab-set--15" type="radio"><label class="tab-label" for="tab-set--15-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell36"><span></span>py -m pip install --index-url http://index.example.com/simple/ SomeProject
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell36">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>If you want to allow packages from both the <a class="reference internal" href="../../glossary/#term-Python-Package-Index-PyPI"><span class="xref std std-term">Python Package Index (PyPI)</span></a>
and a separate index, you can use the <code class="docutils literal notranslate"><span class="pre">--extra-index-url</span></code> flag instead:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--16-input--1" name="tab-set--16" type="radio"><label class="tab-label" for="tab-set--16-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell37"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--extra-index-url<span class="w"> </span>http://index.example.com/simple/<span class="w"> </span>SomeProject
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell37">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--16-input--2" name="tab-set--16" type="radio"><label class="tab-label" for="tab-set--16-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell38"><span></span>py -m pip install --extra-index-url http://index.example.com/simple/ SomeProject
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell38">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="upgrading-packages">
<h2>Upgrading packages<a class="headerlink" href="#upgrading-packages" title="Permalink to this headline">¶</a></h2>
<p>pip can upgrade packages in-place using the <code class="docutils literal notranslate"><span class="pre">--upgrade</span></code> flag. For example, to
install the latest version of <code class="docutils literal notranslate"><span class="pre">requests</span></code> and all of its dependencies:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--17-input--1" name="tab-set--17" type="radio"><label class="tab-label" for="tab-set--17-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell39"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>--upgrade<span class="w"> </span>requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell39">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--17-input--2" name="tab-set--17" type="radio"><label class="tab-label" for="tab-set--17-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell40"><span></span>py -m pip install --upgrade requests
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell40">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="using-requirements-files">
<h2>Using requirements files<a class="headerlink" href="#using-requirements-files" title="Permalink to this headline">¶</a></h2>
<p>Instead of installing packages individually, pip allows you to declare all
dependencies in a <a class="reference external" href="https://pip.pypa.io/en/latest/user_guide/#requirements-files" title="(in pip v23.1)"><span class="xref std std-ref">Requirements File</span></a>. For
example you could create a <code class="file docutils literal notranslate"><span class="pre">requirements.txt</span></code> file containing:</p>
<div class="highlight-text notranslate"><div class="highlight"><pre id="codecell41"><span></span>requests==2.18.4
google-auth==1.1.0
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell41">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>And tell pip to install all of the packages in this file using the <code class="docutils literal notranslate"><span class="pre">-r</span></code> flag:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--18-input--1" name="tab-set--18" type="radio"><label class="tab-label" for="tab-set--18-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell42"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>install<span class="w"> </span>-r<span class="w"> </span>requirements.txt
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell42">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--18-input--2" name="tab-set--18" type="radio"><label class="tab-label" for="tab-set--18-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell43"><span></span>py -m pip install -r requirements.txt
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell43">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
</section>
<section id="freezing-dependencies">
<h2>Freezing dependencies<a class="headerlink" href="#freezing-dependencies" title="Permalink to this headline">¶</a></h2>
<p>Pip can export a list of all installed packages and their versions using the
<code class="docutils literal notranslate"><span class="pre">freeze</span></code> command:</p>
<div class="tab-set docutils container">
<input checked="True" class="tab-input" id="tab-set--19-input--1" name="tab-set--19" type="radio"><label class="tab-label" for="tab-set--19-input--1">Unix/macOS</label><div class="tab-content docutils container">
<div class="highlight-bash notranslate"><div class="highlight"><pre id="codecell44"><span></span>python3<span class="w"> </span>-m<span class="w"> </span>pip<span class="w"> </span>freeze
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell44">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
<input class="tab-input" id="tab-set--19-input--2" name="tab-set--19" type="radio"><label class="tab-label" for="tab-set--19-input--2">Windows</label><div class="tab-content docutils container">
<div class="highlight-bat notranslate"><div class="highlight"><pre id="codecell45"><span></span>py -m pip freeze
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell45">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
</div>
</div>
<p>Which will output a list of package specifiers such as:</p>
<div class="highlight-text notranslate"><div class="highlight"><pre id="codecell46"><span></span>cachetools==2.0.1
certifi==2017.7.27.1
chardet==3.0.4
google-auth==1.1.1
idna==2.6
pyasn1==0.3.6
pyasn1-modules==0.1.4
requests==2.18.4
rsa==3.4.2
six==1.11.0
urllib3==1.22
</pre><button class="copybtn o-tooltip--left" data-tooltip="Copy" data-clipboard-target="#codecell46">
      <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-copy" width="44" height="44" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
  <title>Copy to clipboard</title>
  <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
  <rect x="8" y="8" width="12" height="12" rx="2"></rect>
  <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
</svg>
    </button></div>
</div>
<p>This is useful for creating <a class="reference external" href="https://pip.pypa.io/en/latest/user_guide/#requirements-files" title="(in pip v23.1)"><span>Requirements Files</span></a> that can re-create
the exact versions of all packages installed in an environment.</p>
</section>
