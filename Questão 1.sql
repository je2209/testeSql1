-- TESTE SQL QUESTÃO 1 A)

SELECT 
    escola.nome AS nome_da_escola,
    aluno.data_de_matricula::date AS data_da_matricula,
    COUNT(*) AS quantidade_de_alunos,
    SUM(curso.valor_da_matricula) AS valor_total_arrecadado
FROM 
    alunos AS aluno
JOIN 
    cursos AS curso ON aluno.id_do_curso = curso.id
JOIN 
    escolas AS escola ON curso.id_da_escola = escola.id
WHERE 
    LOWER(curso.nome) LIKE 'data%'
GROUP BY 
    escola.nome, aluno.data_de_matricula
ORDER BY 
    aluno.data_de_matricula DESC;

-- TESTE SQL QUESTÃO 1 B)

WITH dados_diarios AS (
    SELECT 
        escola.nome AS nome_da_escola,
        aluno.data_de_matricula::date AS data_da_matricula,
        COUNT(*) AS quantidade_de_alunos
    FROM 
        alunos AS aluno
    JOIN 
        cursos AS curso ON aluno.id_do_curso = curso.id
    JOIN 
        escolas AS escola ON curso.id_da_escola = escola.id
    WHERE 
        LOWER(curso.nome) LIKE 'data%'
    GROUP BY 
        escola.nome, aluno.data_de_matricula
),
analise_acumulada AS (
    SELECT 
        nome_da_escola,
        data_da_matricula,
        quantidade_de_alunos,
        SUM(quantidade_de_alunos) OVER (
            PARTITION BY nome_da_escola 
            ORDER BY data_da_matricula
        ) AS soma_acumulada_de_alunos,
        AVG(quantidade_de_alunos) OVER (
            PARTITION BY nome_da_escola 
            ORDER BY data_da_matricula 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS media_movel_7_dias,
        AVG(quantidade_de_alunos) OVER (
            PARTITION BY nome_da_escola 
            ORDER BY data_da_matricula 
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) AS media_movel_30_dias
    FROM 
        dados_diarios
)
SELECT *
FROM analise_acumulada
ORDER BY nome_da_escola, data_da_matricula DESC;

