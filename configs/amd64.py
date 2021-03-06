target_triple = "x86_64-linux-gnu"
def config_x86_64(option, opt_str, value, parser):
    config = parser.values
    config.arch_dirs    = [ "x86_64code" ]
    config.arch_cflags  = "-integrated-cpp -target " + target_triple
    config.arch_ldflags = ""
    config.expect_url   = "http://pp.info.uni-karlsruhe.de/git/firm-testresults/plain/fail_expectations-" + target_triple

configurations = {
    'amd64':       config_x86_64,
    target_triple: config_x86_64,
}
