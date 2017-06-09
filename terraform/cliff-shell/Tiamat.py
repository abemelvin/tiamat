import sys
import os
import logging
import cliff
from cliff.app import App
from cliff.command import Command
from cliff.commandmanager import CommandManager
import subprocess

# global state variables
is_deployed = False
ansible_ip = ""


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
            'ansible': Ansible
        }
        for k, v in commands.iteritems():
            self.command_manager.add_command(k, v)

        self.command_manager.add_command('complete', cliff.complete.CompleteCommand)

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
            p = subprocess.Popen("terraform apply", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            result = ""
            while True:
                output = p.stdout.readline()
                result += output
                if output == '' and p.poll() is not None:
                    break
                if output:
                    print output.strip()

            # result = p.stdout.read()
            ip_beg = result.find("ansible ip") + 13
            ip_end = result.find("\n",ip_beg)
            global ansible_ip
            ansible_ip = result[ip_beg:ip_end]
            # self.app.stdout.write(ansible_ip)
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


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))