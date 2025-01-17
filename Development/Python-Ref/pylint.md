[back](./README.md)

# Pylint
[Pylint](https://pylint.pycqa.org/en/latest/user_guide/run.html)

Pylint is a tool that checks for errors in Python code, tries to enforce a coding standard and looks for [code smells](https://martinfowler.com/bliki/CodeSmell.html). It can also look for certain type errors, it can recommend suggestions about how particular blocks can be refactored and can offer you details about the code's complexity.

Other similar projects would include [pychecker](http://pychecker.sf.net) (now defunct), [pyflakes](https://github.com/pyflakes/pyflakes), [flake8](https://gitlab.com/pycqa/flake8/), and [mypy](https://github.com/python/mypy). The default coding style used by Pylint is close to [PEP 8](https://www.python.org/dev/peps/pep-0008/).

Pylint will display a number of messages as it analyzes the code and it can also be used for displaying some statistics about the number of warnings and errors found in different files. The messages are classified under various categories such as errors and warnings.

Last but not least, the code is given an overall mark, based on the number and severity of the warnings and errors.

### Example output: 
```
************* Module valheim_server.log_parser
valheim_server/log_parser.py:1:0: C0114: Missing module docstring (missing-module-docstring)
valheim_server/log_parser.py:4:0: C0115: Missing class docstring (missing-class-docstring)
valheim_server/log_parser.py:16:19: C0103: Variable name "b" doesn't conform to snake_case naming style (invalid-name)
************* Module valheim_server.log_dog
valheim_server/log_dog.py:1:0: C0114: Missing module docstring (missing-module-docstring)
valheim_server/log_dog.py:19:0: C0115: Missing class docstring (missing-class-docstring)
valheim_server/log_dog.py:86:16: C0103: Variable name "l" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:102:8: C0103: Variable name "zDOID_connect" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:115:12: C0103: Variable name "e" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:135:16: C0103: Variable name "e" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:165:8: C0103: Variable name "e" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:170:8: C0103: Variable name "e" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:185:4: C0103: Argument name "steamID" doesn't conform to snake_case naming style (invalid-name)
valheim_server/log_dog.py:196:8: C0103: Variable name "e" doesn't conform to snake_case naming style (invalid-name)


Report
======
199 statements analysed.

Statistics by type
------------------

+---------+-------+-----------+-----------+------------+---------+
|type     |number |old number |difference |%documented |%badname |
+=========+=======+===========+===========+============+=========+
|module   |2      |NC         |NC         |0.00        |0.00     |
+---------+-------+-----------+-----------+------------+---------+
|class    |2      |NC         |NC         |0.00        |0.00     |
+---------+-------+-----------+-----------+------------+---------+
|method   |13     |NC         |NC         |69.23       |76.92    |
+---------+-------+-----------+-----------+------------+---------+
|function |0      |NC         |NC         |0           |0        |
+---------+-------+-----------+-----------+------------+---------+



External dependencies
---------------------
::

    steam (valheim_server.log_dog)
      \-webapi (valheim_server.log_dog)



Raw metrics
-----------

+----------+-------+------+---------+-----------+
|type      |number |%     |previous |difference |
+==========+=======+======+=========+===========+
|code      |213    |71.72 |NC       |NC         |
+----------+-------+------+---------+-----------+
|docstring |28     |9.43  |NC       |NC         |
+----------+-------+------+---------+-----------+
|comment   |31     |10.44 |NC       |NC         |
+----------+-------+------+---------+-----------+
|empty     |25     |8.42  |NC       |NC         |
+----------+-------+------+---------+-----------+



Duplication
-----------

+-------------------------+------+---------+-----------+
|                         |now   |previous |difference |
+=========================+======+=========+===========+
|nb duplicated lines      |0     |NC       |NC         |
+-------------------------+------+---------+-----------+
|percent duplicated lines |0.000 |NC       |NC         |
+-------------------------+------+---------+-----------+



Messages by category
--------------------

+-----------+-------+---------+-----------+
|type       |number |previous |difference |
+===========+=======+=========+===========+
|convention |13     |NC       |NC         |
+-----------+-------+---------+-----------+
|refactor   |0      |NC       |NC         |
+-----------+-------+---------+-----------+
|warning    |0      |NC       |NC         |
+-----------+-------+---------+-----------+
|error      |0      |NC       |NC         |
+-----------+-------+---------+-----------+



% errors / warnings by module
-----------------------------

+--------------------------+------+--------+---------+-----------+
|module                    |error |warning |refactor |convention |
+==========================+======+========+=========+===========+
|valheim_server.log_dog    |0.00  |0.00    |0.00     |76.92      |
+--------------------------+------+--------+---------+-----------+
|valheim_server.log_parser |0.00  |0.00    |0.00     |23.08      |
+--------------------------+------+--------+---------+-----------+



Messages
--------

+-------------------------+------------+
|message id               |occurrences |
+=========================+============+
|invalid-name             |9           |
+-------------------------+------------+
|missing-module-docstring |2           |
+-------------------------+------------+
|missing-class-docstring  |2           |
+-------------------------+------------+




------------------------------------------------------------------
Your code has been rated at 9.35/10 (previous run: 9.35/10, +0.00)
```