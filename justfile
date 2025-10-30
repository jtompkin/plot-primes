test:
    PYTHONPATH=src python ./tests/test_plotprimes.py -v

build: test
    python -m build
