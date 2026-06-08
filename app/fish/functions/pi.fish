if type -q nono
    function pi --description 'Run pi in sandbox'
        command nono run --profile pi --allow-cwd -- pi
    end
end
