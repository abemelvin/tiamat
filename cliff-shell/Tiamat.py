import sys
import os
import logging
import cliff
from cliff.app import App
from cliff.command import Command
from cliff.commandmanager import CommandManager


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
            'destroy': Destroy
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
        parser.add_argument('config_name')
        parser.add_argument('--caps', action='store_true')
        return parser

    def take_action(self, parsed_args):
        # self.log.info('sending greeting')
        self.log.debug('debugging')
        output = 'start deploying environment ' + parsed_args.config_name + '\n'
        if parsed_args.caps:
            output = output.upper()
        self.app.stdout.write(output)


class Destroy(Command):
    """A simple command that prints a message."""

    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        self.app.stdout.write('start destroying environment...\n')

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))