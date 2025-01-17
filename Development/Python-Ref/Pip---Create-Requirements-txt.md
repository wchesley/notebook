[back](./README.md)

# Pip - Create Requirements.txt

Created: April 7, 2021 3:41 PM

```python
pip3 freeze > requirements.txt  # Python3
pip freeze > requirements.txt  # Python2
```

Unless using a virtualenv for pip, this will freeze all libraries used by the system as well as the application. 