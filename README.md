# stepXXX-fastqc

Module to run [FastQC](https://github.com/s-andrews/FastQC/releases)
on one or more FASTQ files and produce QC reports. 

To use this module, first create a configuration file from the
template.

    $ cp config-template.bash config.bash

Then update `config.bash` according to your needs.

Finally, run the module

    $ ./doit.bash

By default, this module uses the [Docker](https://www.docker.com/) image,

<https://hub.docker.com/r/pvstodghill/fastqc/>

To use a use a native executables, uncomment the "HOWTO" assignment in
the configuration file.

By default, this modules uses all available threads. To use a
different thread count, uncomment and update the "THREADS=..."
assignment in the configuration file.
