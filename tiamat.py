import importlib
import datetime
import site
import sys
import os
import logging
import subprocess
import json
import pexpect
from os import listdir
from os.path import isfile, join

try:
    import pip
except ImportError:
    print("This tool requires 'pip' to install some dependencies. Try installing 'pip' and come back!")
    exit(1)
try:
    import cliff
except ImportError:
    print("Did not find 'python-cliff', installing...")
    try:
        subprocess.check_call("pip install --user cliff >/dev/null 2>&1", shell=True)
    except subprocess.CalledProcessError:
        print("Could not install 'python-cliff', exiting...")
        exit(1)
    print("Finished installing 'python-cliff'.")
    reload(site)
    globals()['cliff'] = importlib.import_module('cliff')

from cliff.app import App
from cliff.command import Command
from cliff.commandmanager import CommandManager
from distutils.spawn import find_executable


class Tiamat(App):

    def __init__(self):
        super(Tiamat, self).__init__(
            description='cliff-based interactive command line interface',
            version='0.1',
            command_manager=CommandManager("Tiamat"),
            deferred_help=True,
        )
        commands = {
            'build': Build,
            'runbook': RunBook,
            'deploy': Deploy,
            'destroy': Destroy,
            'ansible': Ansible,
            'wazuh': Wazuh,
            'save logs': ElkFiles,
            'elk': Elk,
            'show active servers': ShowActive,
            'show deployment list': ShowServers,
            'add server': AddServers,
            'remove server': RemoveServers,
            'show available': ShowAvailableServers
        }
        for k, v in commands.iteritems():
            self.command_manager.add_command(k, v)

        self.command_manager.add_command('complete', cliff.complete.CompleteCommand)

        # os platform check
        global os_platform
        if sys.platform.startswith('linux'):
            os_platform = "Linux"
            os.chdir("..")
            subprocess.check_call("sudo chmod -R 777 tiamat", shell=True)
            os.chdir("tiamat")
        elif sys.platform.startswith('darwin'):
            os_platform = "OS X"
        elif sys.platform.startswith('win32') or sys.platform.startswith('cygwin'):
            os_platform = "Windows"

        is_64bits = sys.maxsize > 2 ** 32
        global local_path

        # start dependencies check
        environment_errors = list()
        # print os.environ["AWS_DEFAULT_REGION"]
        if "AWS_ACCESS_KEY_ID" not in os.environ:
            environment_errors.append("Environment variable AWS_ACCESS_KEY_ID is missing. Please check your ~/.bash_profile.")

        if "AWS_SECRET_ACCESS_KEY" not in os.environ:
            environment_errors.append("Environment variable AWS_SECRET_ACCESS_KEY is missing. Please check your ~/.bash_profile.")

        if "AWS_DEFAULT_REGION" not in os.environ:
            environment_errors.append("Environment variable AWS_DEFAULT_REGION is missing. Please check your ~/.bash_profile.")

        if len(environment_errors) > 0:
            print "Environment errors:"
            for row in environment_errors:
                print row
            print "Exiting..."
            exit(1)

        if not find_executable('terraform'):
            ans = raw_input("Could not find Terraform binary in PATH, download? (y/n): ")

            if ans == 'y' or ans == 'yes':

                local_file_path = local_path + '/terraform.zip'

                if os_platform == "Linux":
                    if is_64bits:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "linux_amd64.zip?_ga=2.142026481.2126347023.1497377866-658368258.1496936210"
                    else:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "linux_386.zip?_ga=2.137897971.2126347023.1497377866-658368258.1496936210"
                    wget_call = "sudo wget " + url + " -O " + local_file_path + " > /dev/null 2>&1"
                    subprocess.check_call(wget_call, shell=True)  # check this command
                    unzip_call = "sudo unzip " + local_file_path + " -d " + local_path + " > /dev/null 2>&1"
                    try:
                        subprocess.check_call(unzip_call, shell=True)
                    except subprocess.CalledProcessError as e:
                        sys.stdout.write("Did not find 'unzip', installing...")
                        try:
                            subprocess.check_call("sudo apt-get -y install unzip > /dev/null 2>&1", shell=True)
                        except subprocess.CalledProcessError as e:
                            print "Could not install 'unzip', exiting..."
                            exit(1)
                        sys.stdout.write("Finished installing 'unzip'.\n")
                        subprocess.check_call(unzip_call, shell=True)

                elif os_platform == "OS X":
                    url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8" + \
                        "_darwin_amd64.zip?_ga=2.76410710.2126347023.1497377866-658368258.1496936210"
                    curl_call = "curl " + url + " -o " + local_file_path + " > /dev/null 2>&1"
                    subprocess.check_call(curl_call, shell=True)
                    unzip_call = "unzip " + local_file_path + "-d " + local_path + " > /dev/null 2>&1"
                    try: 
                        subprocess.check_call(unzip_call, shell=True)
                    except subprocess.CalledProcessError as e:
                        print "Failed to unzip terraform, maybe you don't have 'unzip' installed?"
                        print "You can also manually extract terraform into tiamat/ and restart this program."
                        print "Exiting..."
                        exit(1)

                elif os_platform == "Windows":
                    if is_64bits:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "windows_amd64.zip?_ga=2.176148193.2126347023.1497377866-658368258.1496936210"
                    else:
                        url = "https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_" + \
                            "windows_386.zip?_ga=2.176148193.2126347023.1497377866-658368258.1496936210"

                    wget_call = "wget " + url + " -O " + local_path
                    subprocess.check_call(wget_call, shell=True)  # check this command

                    unzip_call = "unzip " + local_file_path + "-d " + local_path
                    try: 
                        subprocess.check_call(unzip_call, shell=True)
                    except subprocess.CalledProcessError as e:
                        print "Failed to unzip terraform, maybe you don't have 'unzip' installed?"
                        print "You can also manually extract terraform into tiamat/ and restart this program."
                        print "Exiting..."
                        exit(1)

                else:
                    print "Error: could not determine your OS. Please download Terraform manually."
                    url = ""
                    print "Exiting..."
                    exit(1)

                os.environ["PATH"] += os.pathsep + os.getcwd()
                print "Added", os.getcwd(), "to your PATH variable."

            else:
                exit(1)
        else:
            pass
            # print find_executable('terraform')

        if not find_executable('packer'):
            ans = raw_input("Could not find packer binary in PATH, download? (y/n): ")

            if ans == 'y' or ans == 'yes':
                # local_file_path = local_path + '/packer.zip' # specify suffix

                if os_platform == "Linux":
                    if is_64bits:
                        url = "https://releases.hashicorp.com/packer/1.0.3/packer_1.0.3_linux_amd64.zip?_ga=" \
                              "2.71732304.212414705.1501080103-1241354470.1501080103"
                        local_file_path = local_path + '/packer_1.0.3_linux_amd64.zip'
                    else:
                        url = "https://releases.hashicorp.com/packer/1.0.3/packer_1.0.3_linux_386.zip?_ga=" \
                              "2.75875030.212414705.1501080103-1241354470.1501080103"
                        local_file_path = local_path + '/packer_1.0.3_linux_386.zip'
                    wget_call = "sudo wget " + url + " -O " + local_file_path + " > /dev/null 2>&1"
                    subprocess.check_call(wget_call, shell=True)  # check this command
                    unzip_call = "sudo unzip " + local_file_path + " -d " + local_path + " > /dev/null 2>&1"
                    try:
                        subprocess.check_call(unzip_call, shell=True)
                    except subprocess.CalledProcessError as e:
                        sys.stdout.write("Did not find 'unzip', installing...")
                        try:
                            subprocess.check_call("sudo apt-get -y install unzip > /dev/null 2>&1", shell=True)
                        except subprocess.CalledProcessError as e:
                            print "Could not install 'unzip', exiting..."
                            exit(1)
                        sys.stdout.write("Finished installing 'unzip'.\n")
                        subprocess.check_call(unzip_call, shell=True)

                elif os_platform == "OS X":
                    url = "https://releases.hashicorp.com/packer/1.0.3/packer_1.0.3_darwin_amd64.zip?_ga=" \
                          "2.79659095.212414705.1501080103-1241354470.1501080103"
                    local_file_path = local_path + '/packer_1.0.3_darwin_amd64.zip'
                    curl_call = "curl " + url + " -o " + local_file_path + " > /dev/null 2>&1"
                    subprocess.check_call(curl_call, shell=True)
                    unzip_call = "unzip " + local_file_path + "-d " + local_path + " > /dev/null 2>&1"
                    try:
                        subprocess.check_call(unzip_call, shell=True)
                    except subprocess.CalledProcessError as e:
                        print "Failed to unzip terraform, maybe you don't have 'unzip' installed?"
                        print "You can also manually extract terraform into tiamat/ and restart this program."
                        print "Exiting..."
                        exit(1)

                os.environ["PATH"] += os.pathsep + os.getcwd()
                print "Added", os.getcwd(), "to your PATH variable."

            else:
                exit(1)

        try:
            if os_platform != "Windows":
                subprocess.check_call("sudo chmod 0600 key", shell=True)
        except subprocess.CalledProcessError as e:
            print e
            exit(1)

        with open('./overrides/configuration.tf', 'r') as file:
            filedata = file.read()
        with open('configuration.tf', 'w') as file:
            file.write(filedata)
        with open('./overrides/elk_override.tf', 'r') as file:
            filedata = file.read()
        with open('elk_override.tf', 'w') as file:
            file.write(filedata)
        with open('./overrides/wazuh_override.tf', 'r') as file:
            filedata = file.read()
        with open('wazuh_override.tf', 'w') as file:
            file.write(filedata)
        print "Welcome to Threat Instrumentation And Machine Automation Tool (TIAMAT)!"
        print "For a list of available commands, use 'help'. To exit, use 'quit'."

    def initialize_app(self, argv):
            self.LOG.debug('initialize_app')

    def prepare_to_run_command(self, cmd):
            self.LOG.debug('prepare_to_run_command %s', cmd.__class__.__name__)

    def clean_up(self, cmd, result, err):
            self.LOG.debug('clean_up %s', cmd.__class__.__name__)
            if err:
                self.LOG.debug('got an error: %s', err)


class Build(Command):
    log = logging.getLogger(__name__)

    #def get_parser(self, prog_name):
    #    parser = super(Build, self).get_parser(prog_name)
    #    parser.add_argument('machine')
    #    return parser

    def take_action(self, parsed_args):
        print("****************************** READ BEFORE BUILDING ******************************")
        print("It is crucial to disable automatic sleep/hibernation on your computer. It will interrupt this process.")
        print("The build process will use AWS EBS to create all images from scratch.")
        print("This process may take a long time. It will also erase previous AMI numbers from your Terraform configuration files.")
        ans = raw_input("Continue? (y/n): ")
        if ans != 'y':
            print("Discontinuing build.")
            return
        os.chdir("images")
        ami_list = list()
        #if parsed_args.machine == 'all':
        for filename in os.listdir("."):
            if os.path.splitext(filename)[1] == '.json':
                print "Building " + filename + "..."
                build_call = "packer build " + filename
                p = subprocess.Popen(build_call, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                result = ""
                while True:
                    output = p.stdout.readline()
                    result += output
                    if output == '' and p.poll() is not None:
                        break
                    if output:
                        print output.strip()
            else:
                print("Excluding file: " + filename)
            
            id_begin = result.find("amazon-ebs: AMI: ami-") + 17
            id_end = result.find("amazon-ebs: AMI: ami-") + 29
            ami_list.append([os.path.splitext(filename)[0], result[id_begin:id_end]])
        for row in ami_list:
            if 'ami' not in row[1]:
                print("There was an error building " + row[0] + ". Discarding AMI ID.")
                del row
        print("Successful builds:")
        for row in ami_list:
            print("- " + row[0] + ": " + row[1])
        os.chdir("../clean_overrides")
        for row in ami_list:
            if row[0] == 'ansible':
                with open('configuration.tf', 'r') as file:
                    filedata = file.read()
                filedata = filedata.replace('(ansible-ami)', row[1])
                with open('../overrides/configuration.tf', 'w') as file:
                    file.write(filedata)
                with open('../configuration.tf', 'w') as file:
                    file.write(filedata)
            elif row[0] == 'elk':
                with open('elk_override.tf', 'r') as file:
                    filedata = file.read()
                filedata = filedata.replace('(elk-ami)', row[1])
                with open('../overrides/elk_override.tf', 'w') as file:
                    file.write(filedata)
                with open('../elk_override.tf', 'w') as file:
                    file.write(filedata)
            elif row[0] == 'wazuh':
                with open('wazuh_override.tf', 'r') as file:
                    filedata = file.read()
                filedata = filedata.replace('(wazuh-ami)', row[1])
                with open('../overrides/wazuh_override.tf', 'w') as file:
                    file.write(filedata)
                with open('../wazuh_override.tf', 'w') as file:
                    file.write(filedata)
            else:
                for filename in os.listdir("."):
                    if row[0] in filename:
                        with open(filename, 'r') as file:
                            filedata = file.read()
                        filedata = filedata.replace('(build-ami)', row[1])
                        with open('../overrides/' + filename, 'w') as file:
                            file.write(filedata)
        os.chdir("..")


class Deploy(Command):
    """Apply the environment configuration"""
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(Deploy, self).get_parser(prog_name)
        parser.add_argument('--config_name', default='test')
        parser.add_argument('--caps', action='store_true')
        return parser

    @staticmethod
    def parse_ip(result, server):
        target = server + " ip"
        ip_beg = result.find(target) + len(target) + 3
        ip_end = result.find("\n", ip_beg)
        return result[ip_beg:ip_end]

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        output = 'start deploying environment ' + parsed_args.config_name + '\n'
        if parsed_args.caps:
            output = output.upper()
        self.app.stdout.write(output)

        global state
        global deploy_server_list

        if not state.is_deployed:
            if len(deploy_server_list) == 0:
                print "Error: deployment list is empty."

            try:
                subprocess.check_call("terraform plan -detailed-exitcode", shell=True)
            except subprocess.CalledProcessError as e:
                if e.returncode == 0:
                    pass
                if e.returncode == 1:
                    print "\nError predicted by terraform plan. Please check the configuration before deployment."
                    ans = raw_input("Do you want to deploy anyway? y/n ")
                    if ans != 'y' and ans != 'yes':
                        return
                if e.returncode == 2:
                    pass

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

            # parse deployed servers ip
            for server in deploy_server_list:
                state.ip[server] = Deploy.parse_ip(result, server)

            state.is_deployed = True

            state.active_server_list = list(deploy_server_list)
            # state.active_server_list.append('ansible')
            # state.active_server_list.append('elk')
            # state.active_server_list.append('wazuh')
            global local_path
            with open(local_path + "/global_state.json", "w+") as global_state:
                json.dump(state.__dict__, global_state)
            global_state.close()
        else:
            self.app.stdout.write("Error: environment already deployed. To re-deploy an environment" +
                                  ", please apply destroy first.\n")


class Destroy(Command):
    """Destroy the applied environment"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        self.app.stdout.write('start destroying environment...\n')
        subprocess.call("terraform destroy", shell=True)
        global state
        global local_path
        state.is_deployed = False
        state.ip.clear()
        state.active_server_list = []
        with open(local_path + "/global_state.json", "w+") as global_state:
            json.dump(state.__dict__, global_state)
        global_state.close()


class Ansible(Command):
    """Open a nested Ansible shell"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global state
        if "ansible" not in state.ip.keys():
            self.app.stdout.write("Error: Ansible IP unavailable.\n")
            return

        ssh_call = "ssh -i key ubuntu@" + state.ip["ansible"]
        try:
            subprocess.check_call(ssh_call, shell=True)
        except subprocess.CalledProcessError as err:
            print err


class Wazuh(Command):
    """Open a nested Wazuh shell"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global state
        if "wazuh" not in state.ip.keys():
            self.app.stdout.write("Error: Wazuh IP unavailable.\n")
            return

        ssh_call = "ssh -i key ubuntu@" + state.ip["wazuh"]
        try:
            subprocess.check_call(ssh_call, shell=True)
        except subprocess.CalledProcessError as err:
            print err


class ElkFiles(Command):
    """Copy log files from ELK server to local folder"""
    log = logging.getLogger(__name__)

    #def get_parser(self, prog_name):
    #    parser = super(ElkFiles, self).get_parser(prog_name)
    #    parser.add_argument('local_path')
    #    return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global state
        #global elk_logs_path
        if "elk" not in state.ip.keys():
            self.app.stdout.write("Error: ELK IP unavailable.\n")
            return

        #trial = 1
        #for filename in os.listdir("saved_logs"):
        #    if filename == "trial" + str(trial):
        #        trial += 1
        #os.makedirs("trial" + str(trial))
        #elk_logs_path = "trial" + str(trial)
        elk_logs_path = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
        os.makedirs("saved_logs/" + elk_logs_path)

        # ssh into elk
        child = pexpect.spawn('ssh -i key ubuntu@' + state.ip['elk'])
        flag = child.expect(['key fingerprint', 'ubuntu@'])
        if flag == 0:
            child.sendline('yes')
            child.expect('ubuntu@')
        else:
            pass

        # curl elasticsearch for logs
        child.sendline("curl -XGET 'http://localhost:9200/packetbeat-*/_search?pretty' > /home/ubuntu/packetbeat_logs")
        child.expect('ubuntu@')
        child.sendline("curl -XGET 'http://localhost:9200/metricbeat-*/_search?pretty' > /home/ubuntu/metricbeat_logs")
        child.expect('ubuntu@')
        child.sendline("curl -XGET 'http://localhost:9200/wazuh-alerts-*/_search?pretty' > /home/ubuntu/wazuh_logs")
        child.expect('ubuntu@')

        # log out of elk
        child.sendline('logout')
        child.close()

        # secure copy log data
        scp_call = "scp -i key -r ubuntu@" + state.ip["elk"] + ':' + '/home/ubuntu/packetbeat_logs' + ' ' + 'saved_logs/' + elk_logs_path + '/packetbeat_logs.json'
        subprocess.check_call(scp_call, shell=True)
        scp_call = "scp -i key -r ubuntu@" + state.ip["elk"] + ':' + '/home/ubuntu/metricbeat_logs' + ' ' + 'saved_logs/' + elk_logs_path + '/metricbeat_logs.json'
        subprocess.check_call(scp_call, shell=True)
        scp_call = "scp -i key -r ubuntu@" + state.ip["elk"] + ':' + '/home/ubuntu/wazuh_logs' + ' ' + 'saved_logs/' + elk_logs_path + '/wazuh_logs.json'
        subprocess.check_call(scp_call, shell=True)


class Elk(Command):
    """open the Elk Dashboard in user's default browser"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global state
        if "elk" not in state.ip.keys():
            self.app.stdout.write("Error: ELK IP unavailable.\n")
            return

        global os_platform
        if os_platform == "Linux":
            browser_call = "xdg-open " + 'http://' + state.ip["elk"]
        elif os_platform == "OS X":
            browser_call = "open " + 'http://' + state.ip["elk"]
        elif os_platform == "Windows":
            browser_call = "explorer " + 'http://' + state.ip["elk"]

        subprocess.check_call(browser_call, shell=True)


class ShowActive(Command):
    """show the list of active servers"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global state
        if len(state.active_server_list) == 0:
            print "no active server."
        else:
            for server in state.active_server_list:
                print '-', server + ":", state.ip[server]


class AddServers(Command):
    """add a server to deployment list"""
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(AddServers, self).get_parser(prog_name)
        parser.add_argument('server_name')
        return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global deploy_server_list
        parsed_args.server_name = parsed_args.server_name.lower()
        if parsed_args.server_name not in deploy_server_list:
            config_file_path = "overrides/" + parsed_args.server_name + "_override.tf"
            if not isfile(config_file_path):
                print "Error: no config file for this server."
                return

            cp_call = "cp " + config_file_path + " ."
            subprocess.check_call(cp_call, shell=True)
            deploy_server_list.append(parsed_args.server_name)


class RemoveServers(Command):
    """remove a server from deployment list"""
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(RemoveServers, self).get_parser(prog_name)
        parser.add_argument('server_name')
        return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global deploy_server_list
        if parsed_args.server_name in deploy_server_list:
            rm_call = "rm " + parsed_args.server_name + "_override.tf"
            subprocess.call(rm_call, shell=True)
            deploy_server_list.remove(parsed_args.server_name)


class ShowServers(Command):
    """show the list of servers to be deployed"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global deploy_server_list
        for server in deploy_server_list:
            print "-", server


class ShowAvailableServers(Command):
    """show the list of servers to be deployed"""
    log = logging.getLogger(__name__)

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        global available_server_list
        file_path = "overrides/"
        available_server_list = [f for f in os.listdir(file_path) if isfile(join(file_path, f))]
        if len(available_server_list) > 0:
            for row in available_server_list:
                print "-", row.split('_')[0]
        else:
            print "Didn't find any servers available for deployment, someone deleted all the files in the " \
                  "'tiamat/terraform/overrides/' directory!"


class RunBook(Command):
    log = logging.getLogger(__name__)

    def get_parser(self, prog_name):
        parser = super(RunBook, self).get_parser(prog_name)
        parser.add_argument('runbook_name')
        return parser

    def take_action(self, parsed_args):
        self.log.debug('debugging')
        for filename in os.listdir("./runbooks"):
            if parsed_args.runbook_name == filename:
                expect_call = "python ./runbooks/" + filename
                print "running " + expect_call

                p = subprocess.Popen(expect_call, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                result = ""
                while True:
                    output = p.stdout.readline()
                    result += output
                    if output == '' and p.poll() is not None:
                        break
                    if output:
                        print output.strip()


class GlobalState:
    def __init__(self):
        self.active_server_list = []
        self.ip = {}
        self.is_deployed = False


def main(argv=sys.argv[1:]):
    shell = Tiamat()
    try:
        return_code = shell.run(argv)
    finally:
        global local_path
        with open(local_path + "/global_state.json", "w+") as global_state:
            json.dump(state.__dict__, global_state)
    return return_code

if __name__ == '__main__':
    # global state variables

    local_path = os.getcwd()
    if isfile("global_state.json"):
        state = GlobalState()
        with open("global_state.json", "r") as global_state:
            d = json.load(global_state)
            state.__dict__.update(d)
    else:
        state = GlobalState()

    deploy_server_list = [f.split('_')[0] for f in listdir('.') if isfile(f) and f[-2:] == 'tf']
    deploy_server_list.append("ansible")
    deploy_server_list.append("elk")
    deploy_server_list.append("wazuh")

    if "configuration.tf" in deploy_server_list:
        deploy_server_list.remove('configuration.tf')

    elk_logs_path = ""
    os_platform = ""

    returncode = main(sys.argv[1:])
    # os.remove("global_state.json") # save it in main directory
    for filename in os.listdir("."):
        if ".tf" in filename:
            os.remove(filename)
    print "Tiamat exiting. Please make sure idle servers have been shut down."
    sys.exit(returncode)
