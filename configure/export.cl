(in-package :cg-user)

(defparameter *exports* nil)

;; couldn't use "export" or "exp"
(defstruct nfs-export
  index
  name
  path
  uid
  gid
  umask
  set-mode-bits
  hosts-allow
  rw-users
  ro-users)

(defun define-export (&key name path (uid 9999) (gid 9999)
                           (umask 0) (set-mode-bits 0)
                           hosts-allow rw-users ro-users)
  (when (null name)
    (error ":name must be specified for define-export"))
  (when (null path)
    (error ":path must be specified for define-export"))
  ;; canonicalize
  (let ((canonical-name (user::canonicalize-name name)))
    (unless (user::canonical-name-p canonical-name)
      (error "The export with name '~A' is invalid!" name))
    (if (and hosts-allow (not (listp hosts-allow)))
	(setf hosts-allow (list hosts-allow)))
    (if (and rw-users (not (listp rw-users)))
	(setf rw-users (list rw-users)))
    (if (and ro-users (not (listp ro-users)))
	(setf ro-users (list ro-users)))
    (setf *exports*
      (append *exports*
	      (list
	       (make-nfs-export
		:index (length *exports*)
		:name canonical-name
		:path (user::cleanup-dir path)
		:uid uid
		:gid gid
		:umask umask
		:set-mode-bits set-mode-bits
		:hosts-allow hosts-allow
		:rw-users rw-users
		:ro-users ro-users))))))
