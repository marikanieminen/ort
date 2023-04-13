#!/usr/bin/env bash
# Command completion for ort
# Generated by Clikt

__skip_opt_eq() {
    # this takes advantage of the fact that bash functions can write to local
    # variables in their callers
    (( i = i + 1 ))
    if [[ "${COMP_WORDS[$i]}" == '=' ]]; then
          (( i = i + 1 ))
    fi
}

_ort() {
  local i=1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --config|-c)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--config' || in_param=''
          continue
          ;;
        --error|--warn|--info|--debug)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --stacktrace)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -P)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='-P' || in_param=''
          continue
          ;;
        --help-all)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --generate-completion)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--generate-completion' || in_param=''
          continue
          ;;
        --version|-v)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      advise)
        _ort_advise $(( i + 1 ))
        return
        ;;
      analyze)
        _ort_analyze $(( i + 1 ))
        return
        ;;
      config)
        _ort_config $(( i + 1 ))
        return
        ;;
      download)
        _ort_download $(( i + 1 ))
        return
        ;;
      evaluate)
        _ort_evaluate $(( i + 1 ))
        return
        ;;
      notify)
        _ort_notify $(( i + 1 ))
        return
        ;;
      report)
        _ort_report $(( i + 1 ))
        return
        ;;
      requirements)
        _ort_requirements $(( i + 1 ))
        return
        ;;
      scan)
        _ort_scan $(( i + 1 ))
        return
        ;;
      upload-curations)
        _ort_upload_curations $(( i + 1 ))
        return
        ;;
      upload-result-to-postgres)
        _ort_upload_result_to_postgres $(( i + 1 ))
        return
        ;;
      upload-result-to-sw360)
        _ort_upload_result_to_sw360 $(( i + 1 ))
        return
        ;;
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--config -c --error --warn --info --debug --stacktrace -P --help-all --generate-completion --version -v -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --config)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --error)
      ;;
    --stacktrace)
      ;;
    -P)
      ;;
    --help-all)
      ;;
    --generate-completion)
      ;;
    --version)
      ;;
    --help)
      ;;
    *)
      COMPREPLY=($(compgen -W 'advise analyze config download evaluate notify report requirements scan upload-curations upload-result-to-postgres upload-result-to-sw360' -- "${word}"))
      ;;
  esac
}

_ort_advise() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --output-formats|-f)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-formats' || in_param=''
          continue
          ;;
        --label|-l)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--label' || in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        --advisors|-a)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--advisors' || in_param=''
          continue
          ;;
        --skip-excluded)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --output-dir -o --output-formats -f --label -l --resolutions-file --advisors -a --skip-excluded -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-formats)
      COMPREPLY=($(compgen -W 'JSON XML YAML' -- "${word}"))
      ;;
    --label)
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --advisors)
      ;;
    --skip-excluded)
      ;;
    --help)
      ;;
  esac
}

_ort_analyze() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --input-dir|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--input-dir' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --output-formats|-f)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-formats' || in_param=''
          continue
          ;;
        --repository-configuration-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--repository-configuration-file' || in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        --label|-l)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--label' || in_param=''
          continue
          ;;
        --package-managers|-m)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-managers' || in_param=''
          continue
          ;;
        --not-package-managers|-n)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--not-package-managers' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--input-dir -i --output-dir -o --output-formats -f --repository-configuration-file --resolutions-file --label -l --package-managers -m --not-package-managers -n -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --input-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-formats)
      COMPREPLY=($(compgen -W 'JSON XML YAML' -- "${word}"))
      ;;
    --repository-configuration-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --label)
      ;;
    --package-managers)
      ;;
    --not-package-managers)
      ;;
    --help)
      ;;
  esac
}

_ort_config() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --show-default)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --show-active)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --show-reference)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --check-syntax)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--check-syntax' || in_param=''
          continue
          ;;
        --hocon-to-yaml)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--hocon-to-yaml' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--show-default --show-active --show-reference --check-syntax --hocon-to-yaml -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --show-default)
      ;;
    --show-active)
      ;;
    --show-reference)
      ;;
    --check-syntax)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --hocon-to-yaml)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --help)
      ;;
  esac
}

_ort_download() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --project-url)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--project-url' || in_param=''
          continue
          ;;
        --project-name)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--project-name' || in_param=''
          continue
          ;;
        --vcs-type)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--vcs-type' || in_param=''
          continue
          ;;
        --vcs-revision)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--vcs-revision' || in_param=''
          continue
          ;;
        --vcs-path)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--vcs-path' || in_param=''
          continue
          ;;
        --license-classifications-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--license-classifications-file' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --archive)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --archive-all)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --package-types)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-types' || in_param=''
          continue
          ;;
        --package-ids)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-ids' || in_param=''
          continue
          ;;
        --skip-excluded)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --project-url --project-name --vcs-type --vcs-revision --vcs-path --license-classifications-file --output-dir -o --archive --archive-all --package-types --package-ids --skip-excluded -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --project-url)
      ;;
    --project-name)
      ;;
    --vcs-type)
      ;;
    --vcs-revision)
      ;;
    --vcs-path)
      ;;
    --license-classifications-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --archive)
      ;;
    --archive-all)
      ;;
    --package-types)
      COMPREPLY=($(compgen -W 'PACKAGE PROJECT' -- "${word}"))
      ;;
    --package-ids)
      ;;
    --skip-excluded)
      ;;
    --help)
      ;;
  esac
}

_ort_evaluate() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --output-formats|-f)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-formats' || in_param=''
          continue
          ;;
        --rules-file|-r)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--rules-file' || in_param=''
          continue
          ;;
        --rules-resource)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--rules-resource' || in_param=''
          continue
          ;;
        --copyright-garbage-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--copyright-garbage-file' || in_param=''
          continue
          ;;
        --license-classifications-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--license-classifications-file' || in_param=''
          continue
          ;;
        --package-configuration-dir)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-configuration-dir' || in_param=''
          continue
          ;;
        --package-curations-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-curations-file' || in_param=''
          continue
          ;;
        --package-curations-dir)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-curations-dir' || in_param=''
          continue
          ;;
        --repository-configuration-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--repository-configuration-file' || in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        --label|-l)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--label' || in_param=''
          continue
          ;;
        --check-syntax)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --output-dir -o --output-formats -f --rules-file -r --rules-resource --copyright-garbage-file --license-classifications-file --package-configuration-dir --package-curations-file --package-curations-dir --repository-configuration-file --resolutions-file --label -l --check-syntax -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-formats)
      COMPREPLY=($(compgen -W 'JSON XML YAML' -- "${word}"))
      ;;
    --rules-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --rules-resource)
      ;;
    --copyright-garbage-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --license-classifications-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --package-configuration-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --package-curations-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --package-curations-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --repository-configuration-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --label)
      ;;
    --check-syntax)
      ;;
    --help)
      ;;
  esac
}

_ort_notify() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --notifications-file|-n)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--notifications-file' || in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        --label|-l)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--label' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --notifications-file -n --resolutions-file --label -l -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --notifications-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --label)
      ;;
    --help)
      ;;
  esac
}

_ort_report() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --report-formats|-f)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--report-formats' || in_param=''
          continue
          ;;
        --copyright-garbage-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--copyright-garbage-file' || in_param=''
          continue
          ;;
        --custom-license-texts-dir)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--custom-license-texts-dir' || in_param=''
          continue
          ;;
        --how-to-fix-text-provider-script)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--how-to-fix-text-provider-script' || in_param=''
          continue
          ;;
        --license-classifications-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--license-classifications-file' || in_param=''
          continue
          ;;
        --package-configuration-dir)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-configuration-dir' || in_param=''
          continue
          ;;
        --refresh-resolutions)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --repository-configuration-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--repository-configuration-file' || in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        --report-option|-O)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--report-option' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --output-dir -o --report-formats -f --copyright-garbage-file --custom-license-texts-dir --how-to-fix-text-provider-script --license-classifications-file --package-configuration-dir --refresh-resolutions --repository-configuration-file --resolutions-file --report-option -O -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --report-formats)
      ;;
    --copyright-garbage-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --custom-license-texts-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --how-to-fix-text-provider-script)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --license-classifications-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --package-configuration-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --refresh-resolutions)
      ;;
    --repository-configuration-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --report-option)
      ;;
    --help)
      ;;
  esac
}

_ort_requirements() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '-h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --help)
      ;;
  esac
}

_ort_scan() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --input-path|-p)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--input-path' || in_param=''
          continue
          ;;
        --output-dir|-o)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-dir' || in_param=''
          continue
          ;;
        --output-formats|-f)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--output-formats' || in_param=''
          continue
          ;;
        --label|-l)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--label' || in_param=''
          continue
          ;;
        --scanners|-s)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--scanners' || in_param=''
          continue
          ;;
        --project-scanners)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--project-scanners' || in_param=''
          continue
          ;;
        --package-types)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--package-types' || in_param=''
          continue
          ;;
        --skip-excluded)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        --resolutions-file)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--resolutions-file' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --input-path -p --output-dir -o --output-formats -f --label -l --scanners -s --project-scanners --package-types --skip-excluded --resolutions-file -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --input-path)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-dir)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --output-formats)
      COMPREPLY=($(compgen -W 'JSON XML YAML' -- "${word}"))
      ;;
    --label)
      ;;
    --scanners)
      ;;
    --project-scanners)
      ;;
    --package-types)
      COMPREPLY=($(compgen -W 'PACKAGE PROJECT' -- "${word}"))
      ;;
    --skip-excluded)
      ;;
    --resolutions-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --help)
      ;;
  esac
}

_ort_upload_curations() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --input-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--input-file' || in_param=''
          continue
          ;;
        --server|-s)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--server' || in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--input-file -i --server -s -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --input-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --server)
      COMPREPLY=($(compgen -W 'PRODUCTION DEVELOPMENT LOCAL' -- "${word}"))
      ;;
    --help)
      ;;
  esac
}

_ort_upload_result_to_postgres() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --table-name)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--table-name' || in_param=''
          continue
          ;;
        --column-name)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--column-name' || in_param=''
          continue
          ;;
        --create-table)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --table-name --column-name --create-table -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --table-name)
      ;;
    --column-name)
      ;;
    --create-table)
      ;;
    --help)
      ;;
  esac
}

_ort_upload_result_to_sw360() {
  local i=$1
  local in_param=''
  local fixed_arg_names=()
  local vararg_name=''
  local can_parse_options=1

  while [[ ${i} -lt $COMP_CWORD ]]; do
    if [[ ${can_parse_options} -eq 1 ]]; then
      case "${COMP_WORDS[$i]}" in
        --)
          can_parse_options=0
          (( i = i + 1 ));
          continue
          ;;
        --ort-file|-i)
          __skip_opt_eq
          (( i = i + 1 ))
          [[ ${i} -gt COMP_CWORD ]] && in_param='--ort-file' || in_param=''
          continue
          ;;
        --attach-sources|-a)
          __skip_opt_eq
          in_param=''
          continue
          ;;
        -h|--help)
          __skip_opt_eq
          in_param=''
          continue
          ;;
      esac
    fi
    case "${COMP_WORDS[$i]}" in
      *)
        (( i = i + 1 ))
        # drop the head of the array
        fixed_arg_names=("${fixed_arg_names[@]:1}")
        ;;
    esac
  done
  local word="${COMP_WORDS[$COMP_CWORD]}"
  if [[ "${word}" =~ ^[-] ]]; then
    COMPREPLY=($(compgen -W '--ort-file -i --attach-sources -a -h --help' -- "${word}"))
    return
  fi

  # We're either at an option's value, or the first remaining fixed size
  # arg, or the vararg if there are no fixed args left
  [[ -z "${in_param}" ]] && in_param=${fixed_arg_names[0]}
  [[ -z "${in_param}" ]] && in_param=${vararg_name}

  case "${in_param}" in
    --ort-file)
       COMPREPLY=($(compgen -o default -- "${word}"))
      ;;
    --attach-sources)
      ;;
    --help)
      ;;
  esac
}

complete -F _ort ort
