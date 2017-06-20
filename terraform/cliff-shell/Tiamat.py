import sys
import os
import logging
import subprocess

try:
    import cliff
except ImportError, e:
    subprocess.check_call("pip install cliff", shell=True)

from cliff.app import App
from cliff.command import Command
from cliff.commandmanager import CommandManager
from distutils.spawn import find_executable

# global state variables
is_deployed = False
ansible_ip = ""
elk_ip = ""
elk_logs_path = ""
os_platform = ""


class Tiamat(App):

    def __init__(self):
        super(Tiamat, self).__init__(
            description='cliff-based interactive command line interface',
            version='0.1',
            command_manager=CommandManager("Tiamat"),
            deferred_help=True,
        )
        commands = {
            'deploy': Deploy,
            'destroy': Destroy,
            'ansible': Ansible,
            'get-elk-files': ElkFiles,
            'elk': Elk
        }
        for k, v in commands.iteritems():
            self.command_manager.add_command(k, v)

        self.command_manager.add_command('complete', cliff.complete.CompleteCommand)

        # os platform check
        global os_platform
        if sys.platform.startswith('linux'):
            os_platform = "Linux"
        elif sys.platform.startswith('darwin'):
            os_platform = "OS X"
        elif sys.platform.startswith('win32') or sys.platform.startswith('cygwin'):
            os_platform = "Windows"

        # start dependencies check
        if "AWS_ACCESS_KEY_ID" not in os.environ:
            print "Error: environment variable AWS_ACCESS_KEY_ID is missing."
            exit(1)

        if "AWS_SECRET_ACCESS_KEY" not in os.environ:
            print "Error: environment variable AWS_SECRET_ACCESS_KEY is missing."
            exit(1)

        if "AWS_DEFAULT_REGION" not in os.environ:
            print "Error: environment variable AWS_DEFAULT_REGION is missing."
            exit(1)

        if not find_executable('terraform'):
            ans = raw_input("Error: Terraform is not installed or missing in search path.\n \
            Do you want to install it via Tiamat? y/n ")

            if ans == 'y' or ans == 'yes':
                is_64bits = sys.maxsize > 2 ** 32
                local_path = raw_input("Please input full local file directory --> ")
                local_file_path = local_path + '/terraform.zip'

                if os_platform == "Linux":
                    if is_64bits:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "linux_amd64.zip?_ga=2.142026481.2126347023.1497377866-658368258.1496936210"
                    else:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "linux_386.zip?_ga=2.137897971.2126347023.1497377866-658368258.1496936210"
                    wget_call = "wget " + url + " -O " + local_file_path
                    subprocess.check_call(wget_call, shell=True)  # check this command
                    unzip_call = "unzip " + local_file_path + " -d " + local_path
                    subprocess.check_call(unzip_call, shell=True)

                elif os_platform == "OS X":
                    url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8" + \
                        "_darwin_amd64.zip?_ga=2.76410710.2126347023.1497377866-658368258.1496936210"
                    curl_call = "curl " + url + " -o " + local_file_path
                    subprocess.check_call(curl_call, shell=True)
                    unzip_call = "unzip " + local_file_path + "-d " + local_path
                    subprocess.check_call(unzip_call, shell=True)  # can use -d to assign exp dir

                elif os_platform == "Windows":
                    if is_64bits:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "windows_amd64.zip?_ga=2.176148193.2126347023.1497377866-658368258.1496936210"
                    else:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "windows_386.zip?_ga=2.176148193.2126347023.1497377866-658368258.1496936210"
                    wget_call = "wget " + url + " -O " + local_path
                    subprocess.check_call(wget_call, shell=True)  # check this command
                    subprocess.check_call("unzip " + local_path, shell=True)  # check this command

                else:
                    print "Error: cannot check OS.Please download Terraform manually."
                    url = ""
                    exit(1)

            else:
                exit(1)
        else:
            pass
            # print find_executable('terraform')

    def initialize_app(self, argv):
            self.LOG.debug('initialize_app')

    def prepare_to_run_command(self, cmd):
            self.LOG.debug('prepare_to_run_command %s', cmd.__class__.__name__)

    def clean_up(self, cmd, result, err):
            self.LOG.debug('clean_up %s', cmd.__class__.__name__)
            if err:
                self.LOG.debug('got an error: %s', err)


def main(argv=sys.argv[1:]):
    shell = Tiamat()
    return shell.run(argv)


class Deploy(Command):
    """Apply the environment configuration"""
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(Deploy, self).get_parser(prog_name)
        parser.add_argument('--config_name', default='test')
        parser.add_argument('--caps', action='store_true')
        return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        output = 'start deploying environment ' + parsed_args.config_name + '\n'
        if parsed_args.caps:
            output = output.upper()
        self.app.stdout.write(output)

        global is_deployed
        if not is_deployed:
            try:
                subprocess.check_call("terraform plan -detailed-exitcode", shell=True)
            except subprocess.CalledProcessError:
                print "\nError predicted by terraform plan. Please check the configuration before deploy."
                return

            p = subprocess.Popen("terraform apply", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            result = ""
            while True:
                output = p.stdout.readline()
                result += output
                if output == '' and p.poll() is not None:
                    break
                if output:
                    print output.strip()

            if p.returncode != 0:
                print "\nError: terraform exited abnormally. Return code is %s.\n" % p.returncode
                print p.stderr.read()
                print "Immediate destroy is suggested.\n"
                subprocess.call("terraform destroy", shell=True)
                return

            ansible_ip_beg = result.find("ansible ip") + 13
            ansible_ip_end = result.find("\n", ansible_ip_beg)
            global ansible_ip
            ansible_ip = result[ansible_ip_beg:ansible_ip_end]

            elk_ip_beg = result.find("elk ip") + 9
            elk_ip_end = result.find("\n", elk_ip_beg)
            global elk_ip
            elk_ip = result[elk_ip_beg:elk_ip_end]
            is_deployed = True
        else:
            self.app.stdout.write("Error: environment already deployed.\n")


class Destroy(Command):
    """A simple command that prints a message."""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        self.app.stdout.write('start destroying environment...\n')
        subprocess.call("terraform destroy", shell=True)
        global is_deployed
        is_deployed = False
        global ansible_ip
        ansible_ip = ""


class Ansible(Command):
    """Open a nested Ansible shell"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global ansible_ip
        if not ansible_ip:
            self.app.stdout.write("Error: Ansible IP unavailable.\n")
            return

        ssh_call = "ssh -i key ubuntu@" + ansible_ip
        subprocess.check_call(ssh_call, shell=True)


class ElkFiles(Command):
    """Copy log files from ELK server to local folder"""
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(ElkFiles, self).get_parser(prog_name)
        parser.add_argument('local_path')
        return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global elk_ip
        global elk_logs_path
        if not elk_ip:
            self.app.stdout.write("Error: ELK IP unavailable.\n")
            return

        scp_call = "scp -i key -r ubuntu@" + elk_ip + ':' + elk_logs_path + ' ' + parsed_args.local_path
        subprocess.check_call(scp_call, shell=True)


class Elk(Command):
    """open the Elk Dashboard in user's default browser"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global elk_ip
        if not elk_ip:
            self.app.stdout.write("Error: ELK IP unavailable.\n")
            return

        global os_platform
        if os_platform == "Linux":
            browser_call = "xdg-open " + 'http://' + elk_ip
        elif os_platform == "OS X":
            browser_call = "open " + 'http://' + elk_ip
        elif os_platform == "Windows":
            browser_call = "explorer " + 'http://' + elk_ip

        subprocess.check_call(browser_call, shell=True)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
