import QtQuick
import Quickshell
import Quickshell.Services.Pam

ShellRoot {
    id: root

    // Never reload under a held lock
    settings.watchFiles: false

    function unlock() {
        lock.locked = false;
        Qt.quit();
    }

    PamContext {
        id: pam

        config: "login"
        onResponseRequiredChanged: {
            if (responseRequired)
                respond(lock.password);
        }
        onCompleted: result => {
            if (result === PamResult.Success)
                root.unlock();
            else if (result === PamResult.Failed)
                lock.fail("Incorrect password");
            else
                lock.fail(PamResult.toString(result));
        }
        onError: error => lock.fail(PamError.toString(error))
    }

    LoginLock {
        id: lock

        username: Quickshell.env("USER")
        onSubmitted: {
            if (busy || !password)
                return;
            busy = true;
            message = "";
            messageIsError = false;
            pam.start();
        }
    }
}
