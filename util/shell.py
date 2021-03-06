"""
Convenience function
Alternative to subprocess and os.system
"""
import subprocess
import resource
import sys
import signal

_EXIT_CODES = dict((-k, v) for v, k in signal.__dict__.items() if v.startswith('SIG'))
del _EXIT_CODES[0]


class SigKill(Exception):
    def __init__(self, retcode, name, stdout, stderr):
        self.retcode = retcode
        self.name = name
        self.stdout = stdout
        self.stderr = stderr


def execute(cmd, env=None, timeout=0, shell=False, propagate_sigint=True):
    """Execute a command and return stderr and stdout data"""

    def lower_rlimit(res, limit):
        (soft, hard) = resource.getrlimit(res)
        if soft > limit or soft == resource.RLIM_INFINITY:
            soft = limit
        if hard > limit or hard == resource.RLIM_INFINITY:
            hard = limit
        resource.setrlimit(res, (soft, hard))

    def set_rlimit():
        if timeout > 0.0:
            lower_rlimit(resource.RLIMIT_CPU, timeout)
        MB = 1024 * 1024
        lower_rlimit(resource.RLIMIT_CORE,  0)
        lower_rlimit(resource.RLIMIT_DATA,  1024 * MB)
        lower_rlimit(resource.RLIMIT_STACK, 1024 * MB)
        lower_rlimit(resource.RLIMIT_FSIZE,   32 * MB)

    if not shell:
        cmd = filter(lambda x: x, cmd.split(' '))
    proc = subprocess.Popen(cmd,
                            shell=shell,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            preexec_fn=set_rlimit,
                            env=env)
    out, err = proc.communicate()
    returncode = proc.returncode

    # Propagate Ctrl-C in subprocess
    if propagate_sigint and returncode == -signal.SIGINT:
        raise KeyboardInterrupt

    # Usually python can recognize application terminations triggered by
    # signals, but somehow it doesn't do this for java (I suspect, that java
    # catches the signals itself but then shuts down more 'cleanly' than it
    # should. Calculate to python convention returncode
    if returncode > 127:
        returncode = 128 - returncode
    if returncode in _EXIT_CODES:
        raise SigKill(returncode, _EXIT_CODES[returncode], out, err)
    return (out, err, returncode)


def silent_shell(cmd, env=None, debug=False):
    """Execute a shell command"""
    if debug:
        sys.stderr.write("silent_shell: %s\n" % cmd)
        stdout = None
        stderr = None
    else:
        stdout = open("/dev/null", 'a')
        stderr = subprocess.STDOUT
    try:
        return subprocess.call(cmd, shell=True, stdout=stdout, stderr=stderr, env=env)
    except OSError as e:
        sys.stderr.write("Execution failed: %s\n" % e)


def write_file(filename, content):
    fh = open(filename, 'w')
    fh.write(content)
    fh.close()


if __name__ == "__main__":
    out, err, retcode = execute("hostname")
    print (out)
